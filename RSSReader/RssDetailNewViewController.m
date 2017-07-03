//
//  RssDetailNewViewController.m
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import "RssDetailNewViewController.h"

@interface RssDetailNewViewController ()

@end

@implementation RssDetailNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tituloNoticia.text = _noticia.titulo;
    self.descripcionNoticia.text = _noticia.descripcion;

  _imagenNoticia.image   = [UIImage imageWithData:[_noticia getImagen] ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_noticia.enlace stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

}

@end
