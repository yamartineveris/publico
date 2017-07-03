//
//  Noticia.m
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import "Noticia.h"

@implementation Noticia


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Set primitives
        [copy setTitulo:self.titulo];
        [copy setAutor:self.autor];
        [copy setFecha:self.fecha];
        [copy setDescripcion:self.descripcion];
        [copy setImagenPortada:self.imagenPortada];
        [copy setEnlace:self.enlace];
        
    }
    
    return copy;
}
@end
