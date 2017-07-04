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

- (NSData * )getImagen

{
    if (!_datosImagen)
    {
        NSURL *url = [NSURL URLWithString:_imagenPortada];
        _datosImagen = [[NSData alloc] initWithContentsOfURL:url];
    }
    
    return _datosImagen;
    
    
}


- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:_titulo forKey:@"_titulo"];
    [coder encodeObject:_autor forKey:@"_autor"];
    [coder encodeObject:_fecha forKey:@"_fecha"];
    [coder encodeObject:_descripcion forKey:@"_descripcion"];
    [coder encodeObject:_imagenPortada forKey:@"_imagenPortada"];
    [coder encodeObject:_enlace forKey:@"_enlace"];

}

- (id)initWithCoder:(NSCoder *)coder {
    
    _titulo = [coder decodeObjectForKey:@"_titulo"] ;
    _autor = [coder decodeObjectForKey:@"_autor"] ;
    _fecha = [coder decodeObjectForKey:@"_fecha"] ;
    _descripcion = [coder decodeObjectForKey:@"_descripcion"] ;
    _imagenPortada = [coder decodeObjectForKey:@"_imagenPortada"] ;
    _enlace = [coder decodeObjectForKey:@"_enlace"] ;


    
    return self;
}

@end
