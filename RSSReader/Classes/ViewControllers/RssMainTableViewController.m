//
//  RssMainTableViewController.m
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import "RssMainTableViewController.h"
#import "RSSTableViewCell.h"
#import "RssDetailNewViewController.h"
#import "Noticia.h"


@interface RssMainTableViewController ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    
    NSMutableArray *titles;
    NSMutableArray *descriptions;
    NSMutableArray *links;

    
    NSMutableDictionary *item;
    NSMutableString *titlesString;
    NSMutableString *title;
    NSMutableString *description;

    NSMutableData * data;
    NSMutableString *link;
    NSMutableString *image;
    Noticia *noticia;

    NSString *element;
         }
@end

@implementation RssMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *  color = [UIColor lightGrayColor];

    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:color}];
    // [self.navigationController.navigationBar setTintColor:[UIColor popularDarkBlue]];
    
    // NavigationBar style
    float font = 15;
    
    [self.navigationController.navigationBar setHidden:FALSE];

    
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      color, NSForegroundColorAttributeName,
                                                                      [UIFont fontWithName:@"Geomanist-WZ-Book" size:font], NSFontAttributeName, nil]];
    
    
    // Cambiamos el navigation Title.
    
    [self.navigationItem setTitle:@"RSS Reader"];

    
    UINib *cellNib = [UINib nibWithNibName:@"RSSTableViewCell" bundle:nil];
    [self.tableViewRSS registerNib:cellNib forCellReuseIdentifier:@"RSSCell"];
    self.tableViewRSS.estimatedRowHeight = 100;
        self.tableViewRSS.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableViewRSS setDelegate:self];
    [self.tableViewRSS setDataSource:self];
    
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://www.xatakandroid.com/tag/iphone/rss2.xml"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // RSSTableViewCell * cell = [_tableViewRSS dequeueReusableCellWithIdentifier:@"RSSCell" ];
    
    
    RSSTableViewCell * cell = [_tableViewRSS dequeueReusableCellWithIdentifier:@"RSSCell"  forIndexPath:indexPath];
    Noticia * datos = (Noticia *)[feeds objectAtIndex:indexPath.row];
    
    cell.titulo.text =datos.titulo;
    cell.descripcion.text = datos.descripcion;
    
         cell.imagen.image  = [UIImage imageWithData:[datos getImagen] ];
   
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"detail" sender:nil];
}




- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        
        noticia = [[Noticia alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        image = [[NSMutableString alloc] init];

    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        
        NSString *linkT =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [link appendString:linkT];
    }else if ([element isEqualToString:@"description"]) {

       NSString * result= [self firstImgUrlString:string];
        
        
        if (result)
        {
            [image appendString:result];

        }

        NSString *stringWithoutHTML = [self stringByStrippingHTML:string];
        
        
        [description appendString:stringWithoutHTML];

    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        noticia.titulo = title;
        noticia.descripcion = description;
        noticia.imagenPortada = image;
        noticia.enlace = link;
        
     

        [feeds addObject:[noticia copy]];
        
    }
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableViewRSS reloadData];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (NSString *)firstImgUrlString:(NSString *)string
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:string
                                                     options:0
                                                       range:NSMakeRange(0, [string length])];
    
    if (result)
        return [string substringWithRange:[result rangeAtIndex:2]];
    
    return nil;
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location     != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];


    return str;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     NSIndexPath *indexPath = [self.tableViewRSS indexPathForSelectedRow];
    Noticia * datos = (Noticia *)[feeds objectAtIndex:indexPath.row];


        if([segue.identifier isEqualToString:@"detail"]){
            RssDetailNewViewController *VC = (RssDetailNewViewController*)segue.destinationViewController;
            
        
          
            VC.noticia = datos;
        }
}

@end
