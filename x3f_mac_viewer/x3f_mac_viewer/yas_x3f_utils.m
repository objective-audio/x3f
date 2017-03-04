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

NSData *load_jpg(const char *infile) {
    NSData *resultData = nil;
    
    FILE *f_in = fopen(infile, "rb");
    
    x3f_t *x3f = NULL;
    
    if (f_in == NULL) {
        x3f_printf(ERR, "Could not open infile %s\n", infile);
        goto clean_up;
    }
    
    x3f_printf(INFO, "READ THE X3F FILE %s\n", infile);
    x3f = x3f_new_from_file(f_in);
    
    if (x3f == NULL) {
        x3f_printf(ERR, "Could not read infile %s\n", infile);
        goto clean_up;
    }
    
    if (X3F_OK != x3f_load_data(x3f, x3f_get_thumb_jpeg(x3f))) {
        x3f_printf(ERR, "Could not load JPEG thumbnail from %s\n", infile);
        goto clean_up;
    }
    
    x3f_directory_entry_t *DE = x3f_get_thumb_jpeg(x3f);
    
    if (DE == NULL) {
        goto clean_up;
    } else {
        x3f_directory_entry_header_t *DEH = &DE->header;
        x3f_image_data_t *ID = &DEH->data_subsection.image_data;
        
        resultData = [NSData dataWithBytes:ID->data length:ID->data_size];
    }
    
clean_up:
    
    x3f_delete(x3f);
    
    if (f_in != NULL) {
        fclose(f_in);
    }
    
    return resultData;
}
