//
//  Noticia.h
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Noticia : NSObject

// Propiedades -> XML
@property (copy, nonatomic) NSString *titulo;
@property (copy, nonatomic) NSString *autor;
@property (copy, nonatomic) NSString *fecha;
@property (copy, nonatomic) NSString *descripcion;
@property (copy, nonatomic) NSString *imagenPortada;
@property (copy, nonatomic) NSString *enlace;

//propiedad creada para almacenar la imagen.
@property (copy, nonatomic) NSData *datosImagen;

//metodo para devolver la imagen.
- (NSData * )getImagen;


@end
