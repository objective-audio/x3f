//
//  yas_x3f_utils.c
//  x3f_mac_viewer
//
//  Created by Yuki Yasoshima on 2017/03/04.
//  Copyright © 2017年 Yuki Yasoshima. All rights reserved.
//

#include "yas_x3f_utils.h"
#include "x3f_io.h"
#include "x3f_printf.h"

#define MAXPATH 1000
#define EXTMAX 10
#define MAXOUTPATH (MAXPATH+EXTMAX)
#define MAXTMPPATH (MAXOUTPATH+EXTMAX)

NSData *load_jpg(const char *infile) {
    NSData *resultData = nil;
    
    FILE *f_in = fopen(infile, "rb");
    
    x3f_t *x3f = NULL;
    
    char tmpfile[MAXTMPPATH+1];
    char outfile[MAXOUTPATH+1];
    x3f_return_t ret_dump;
    int sgain;
    
    if (f_in == NULL) {
        x3f_printf(ERR, "Could not open infile %s\n", infile);
        goto found_error;
    }
    
    x3f_printf(INFO, "READ THE X3F FILE %s\n", infile);
    x3f = x3f_new_from_file(f_in);
    
    if (x3f == NULL) {
        x3f_printf(ERR, "Could not read infile %s\n", infile);
        goto found_error;
    }
    
    if (1) {
        if (X3F_OK != x3f_load_data(x3f, x3f_get_thumb_jpeg(x3f))) {
            x3f_printf(ERR, "Could not load JPEG thumbnail from %s\n", infile);
            goto found_error;
        }
    }
    
    x3f_directory_entry_t *DE = x3f_get_thumb_jpeg(x3f);
    
    if (DE == NULL) {
        goto found_error;
        //return X3F_ARGUMENT_ERROR;
    } else {
        x3f_directory_entry_header_t *DEH = &DE->header;
        x3f_image_data_t *ID = &DEH->data_subsection.image_data;
        
        resultData = [NSData dataWithBytes:ID->data length:ID->data_size];
        /*
         if (data == NULL) {
         return X3F_INTERNAL_ERROR;
         } else {
         FILE *f_out = fopen(outfilename, "wb");
         
         if (f_out == NULL) {
         return X3F_OUTFILE_ERROR;
         } else {
         fwrite(data, 1, DE->input.size, f_out);
         fclose(f_out);
         }
         }*/
    }
    
found_error:
    
//    errors++;
    
clean_up:
    
    x3f_delete(x3f);
    
    if (f_in != NULL) {
        fclose(f_in);
    }
    
    return resultData;
}

//int main(int argc, char *argv[])
//{
//    int extract_jpg = 0;
//    int extract_meta; /* Always computed */
//    int extract_raw = 1;
//    int extract_unconverted_raw = 0;
//    int crop = 1;
//    int denoise = 1;
//    int apply_sgain = -1;
//    output_file_type_t file_type = DNG;
//    x3f_color_encoding_t color_encoding = SRGB;
//    int files = 0;
//    int errors = 0;
//    int log_hist = 0;
//    char *wb = NULL;
//    int compress = 0;
//    int use_opencl = 0;
//    char *outdir = NULL;
//    
//    int i;
//    
//    x3f_printf(INFO, "X3F TOOLS VERSION = %s\n\n", version);
//    
//    /* Set stdout and stderr to line buffered mode to avoid scrambling */
//    setvbuf(stdout, NULL, _IOLBF, 0);
//    setvbuf(stderr, NULL, _IOLBF, 0);
//    
//    for (i=1; i<argc; i++)
//        
//    /* Only one of those switches is valid, the last one */
//        if (!strcmp(argv[i], "-jpg"))
//            Z, extract_jpg = 1, file_type = JPEG;
//        else if (!strcmp(argv[i], "-meta"))
//            Z, file_type = META;
//        else if (!strcmp(argv[i], "-raw"))
//            Z, extract_unconverted_raw = 1, file_type = RAW;
//        else if (!strcmp(argv[i], "-tiff"))
//            Z, extract_raw = 1, file_type = TIFF;
//        else if (!strcmp(argv[i], "-dng"))
//            Z, extract_raw = 1, file_type = DNG;
//        else if (!strcmp(argv[i], "-ppm-ascii"))
//            Z, extract_raw = 1, file_type = PPMP3;
//        else if (!strcmp(argv[i], "-ppm"))
//            Z, extract_raw = 1, file_type = PPMP6;
//        else if (!strcmp(argv[i], "-histogram"))
//            Z, extract_raw = 1, file_type = HISTOGRAM;
//        else if (!strcmp(argv[i], "-loghist"))
//            Z, extract_raw = 1, file_type = HISTOGRAM, log_hist = 1;
//    
//        else if (!strcmp(argv[i], "-color") && (i+1)<argc) {
//            char *encoding = argv[++i];
//            if (!strcmp(encoding, "none"))
//                color_encoding = NONE;
//            else if (!strcmp(encoding, "sRGB"))
//                color_encoding = SRGB;
//            else if (!strcmp(encoding, "AdobeRGB"))
//                color_encoding = ARGB;
//            else if (!strcmp(encoding, "ProPhotoRGB"))
//                color_encoding = PPRGB;
//            else {
//                fprintf(stderr, "Unknown color encoding: %s\n", encoding);
//                usage(argv[0]);
//            }
//        }
//        else if (!strcmp(argv[i], "-o") && (i+1)<argc)
//            outdir = argv[++i];
//        else if (!strcmp(argv[i], "-v"))
//            x3f_printf_level = DEBUG;
//        else if (!strcmp(argv[i], "-q"))
//            x3f_printf_level = ERR;
//        else if (!strcmp(argv[i], "-unprocessed"))
//            color_encoding = UNPROCESSED;
//        else if (!strcmp(argv[i], "-qtop"))
//            color_encoding = QTOP;
//        else if (!strcmp(argv[i], "-no-crop"))
//            crop = 0;
//        else if (!strcmp(argv[i], "-no-denoise"))
//            denoise = 0;
//        else if (!strcmp(argv[i], "-no-sgain"))
//            apply_sgain = 0;
//        else if (!strcmp(argv[i], "-sgain"))
//            apply_sgain = 1;
//        else if ((!strcmp(argv[i], "-wb")) && (i+1)<argc)
//            wb = argv[++i];
//        else if (!strcmp(argv[i], "-compress"))
//            compress = 1;
//        else if (!strcmp(argv[i], "-ocl"))
//            use_opencl = 1;
//    
//    /* Strange Stuff */
//        else if ((!strcmp(argv[i], "-offset")) && (i+1)<argc)
//            legacy_offset = atoi(argv[++i]), auto_legacy_offset = 0;
//        else if ((!strcmp(argv[i], "-matrixmax")) && (i+1)<argc)
//            max_printed_matrix_elements = atoi(argv[++i]);
//        else if (!strncmp(argv[i], "-", 1))
//            usage(argv[0]);
//        else
//            break;			/* Here starts list of files */
//    
//    if (outdir != NULL && check_dir(outdir) != 0) {
//        x3f_printf(ERR, "Could not find outdir %s\n", outdir);
//        usage(argv[0]);
//    }
//    
//    x3f_set_use_opencl(use_opencl);
//    
//    extract_meta =
//    file_type == META ||
//    file_type == DNG ||
//    (extract_raw &&
//     (crop || (color_encoding != UNPROCESSED && color_encoding != QTOP)));
//    
//    for (; i<argc; i++) {
//        char *infile = argv[i];
//        FILE *f_in = fopen(infile, "rb");
//        x3f_t *x3f = NULL;
//        
//        char tmpfile[MAXTMPPATH+1];
//        char outfile[MAXOUTPATH+1];
//        x3f_return_t ret_dump;
//        int sgain;
//        
//        files++;
//        
//        if (f_in == NULL) {
//            x3f_printf(ERR, "Could not open infile %s\n", infile);
//            goto found_error;
//        }
//        
//        x3f_printf(INFO, "READ THE X3F FILE %s\n", infile);
//        x3f = x3f_new_from_file(f_in);
//        
//        if (x3f == NULL) {
//            x3f_printf(ERR, "Could not read infile %s\n", infile);
//            goto found_error;
//        }
//        
//        if (extract_jpg) {
//            if (X3F_OK != x3f_load_data(x3f, x3f_get_thumb_jpeg(x3f))) {
//                x3f_printf(ERR, "Could not load JPEG thumbnail from %s\n", infile);
//                goto found_error;
//            }
//        }
//        
//        if (extract_meta) {
//            x3f_directory_entry_t *DE = x3f_get_prop(x3f);
//            
//            if (X3F_OK != x3f_load_data(x3f, x3f_get_camf(x3f))) {
//                x3f_printf(ERR, "Could not load CAMF from %s\n", infile);
//                goto found_error;
//            }
//            if (DE != NULL)
//            /* Not for Quattro */
//                if (X3F_OK != x3f_load_data(x3f, DE)) {
//                    x3f_printf(ERR, "Could not load PROP from %s\n", infile);
//                    goto found_error;
//                }
//            /* We do not load any JPEG meta data */
//        }
//        
//        if (extract_raw) {
//            if (X3F_OK != x3f_load_data(x3f, x3f_get_raw(x3f))) {
//                x3f_printf(ERR, "Could not load RAW from %s\n", infile);
//                goto found_error;
//            }
//        }
//        
//        if (extract_unconverted_raw) {
//            if (X3F_OK != x3f_load_image_block(x3f, x3f_get_raw(x3f))) {
//                x3f_printf(ERR, "Could not load unconverted RAW from %s\n", infile);
//                goto found_error;
//            }
//        }
//        
//        if (make_paths(infile, outdir, extension[file_type], tmpfile, outfile)) {
//            x3f_printf(ERR, "Too large outfile path for infile %s and outdir %s\n",
//                       infile, outdir);
//            goto found_error;
//        }
//        
//        /* TODO: Quattro files seem to be already corrected for spatial
//         gain. Is that assumption correct? Applying it only worsens the
//         result anyhow, so it is disabled by default. */
//        sgain =
//        apply_sgain == -1 ? x3f->header.version < X3F_VERSION_4_0 : apply_sgain;
//        
//        switch (file_type) {
//            case META:
//                x3f_printf(INFO, "Dump META DATA to %s\n", outfile);
//                ret_dump = x3f_dump_meta_data(x3f, tmpfile);
//                break;
//            case JPEG:
//                x3f_printf(INFO, "Dump JPEG to %s\n", outfile);
//                ret_dump = x3f_dump_jpeg(x3f, tmpfile);
//                break;
//            case RAW:
//                x3f_printf(INFO, "Dump RAW block to %s\n", outfile);
//                ret_dump = x3f_dump_raw_data(x3f, tmpfile);
//                break;
//            case TIFF:
//                x3f_printf(INFO, "Dump RAW as TIFF to %s\n", outfile);
//                ret_dump = x3f_dump_raw_data_as_tiff(x3f, tmpfile,
//                                                     color_encoding,
//                                                     crop, denoise, sgain, wb,
//                                                     compress);
//                break;
//            case DNG:
//                x3f_printf(INFO, "Dump RAW as DNG to %s\n", outfile);
//                ret_dump = x3f_dump_raw_data_as_dng(x3f, tmpfile,
//                                                    denoise, sgain, wb,
//                                                    compress);
//                break;
//            case PPMP3:
//            case PPMP6:
//                x3f_printf(INFO, "Dump RAW as PPM to %s\n", outfile);
//                ret_dump = x3f_dump_raw_data_as_ppm(x3f, tmpfile,
//                                                    color_encoding,
//                                                    crop, denoise, sgain, wb,
//                                                    file_type == PPMP6);
//                break;
//            case HISTOGRAM:
//                x3f_printf(INFO, "Dump RAW as CSV histogram to %s\n", outfile);
//                ret_dump = x3f_dump_raw_data_as_histogram(x3f, tmpfile,
//                                                          color_encoding,
//                                                          crop, denoise, sgain, wb,
//                                                          log_hist);
//                break;
//        }
//        
//        if (X3F_OK != ret_dump) {
//            x3f_printf(ERR, "Could not dump to %s: %s\n", tmpfile, x3f_err(ret_dump));
//            errors++;
//        } else {
//            if (rename(tmpfile, outfile) != 0) {
//                x3f_printf(ERR, "Could not rename %s to %s\n", tmpfile, outfile);
//                errors++;
//            }
//        }
//        
//        goto clean_up;
//        
//    found_error:
//        
//        errors++;
//        
//    clean_up:
//        
//        x3f_delete(x3f);
//        
//        if (f_in != NULL)
//            fclose(f_in);
//    }
//    
//    if (files == 0) {
//        x3f_printf(ERR, "No files given\n");
//        usage(argv[0]);
//    }
//    
//    x3f_printf(INFO, "Files processed: %d\terrors: %d\n", files, errors);
//    
//    return errors > 0;
//}
