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
    
    NSURL *url = [NSURL URLWithString:_noticia.imagenPortada];
    NSData *dataImage = [[NSData alloc] initWithContentsOfURL:url];
    _imagenNoticia.image  = [UIImage imageWithData:dataImage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
