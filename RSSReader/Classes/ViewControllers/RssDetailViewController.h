//
//  RssDetailViewController.h
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Noticia.h"

@interface RssDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tituloNoticia;
@property (weak, nonatomic) IBOutlet UITextView *descripcionNoticia;
@property  (weak, nonatomic)    Noticia *noticia;
@property (weak, nonatomic) IBOutlet UIButton *buttonOpenSafari;

@property (weak, nonatomic) IBOutlet UIImageView *imagenNoticia;

@end
