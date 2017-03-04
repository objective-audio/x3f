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
