//
//  RssMainTableViewController.m
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import "RssMainTableViewController.h"
#import "RSSTableViewCell.h"
#import "RssDetailViewController.h"
#import "Noticia.h"
#import "RSSUtils.h"

//CONSTANTS

#define kBaseURLRSS @"https://www.xatakandroid.com/tag/iphone/rss2.xml"
#define kNibRssCell @"RSSTableViewCell"
#define kRSSCell @"RSSTableViewCell"
#define kSegueDetail @"detail"


@interface RssMainTableViewController ()
{
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSArray *searchResults;
    NSMutableDictionary *item;
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


#pragma mark - View

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    //Configuramos vista
    UIColor *  color = [UIColor lightGrayColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:color}];
    [self.navigationController.navigationBar setHidden:FALSE];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor lightGrayColor]];
    // Cambiamos el navigation Title.
    
    [self.navigationItem setTitle:NSLocalizedString(@"RSS_STRING_TITLE", nil)];
    _tableViewRSS.hidden = true;
    _tableViewRSS.backgroundColor = [UIColor blueColor];
    
    
    [self loadData];
    [self configureSearch];
    
    
}

-(void) registerTableView

{
    UINib *cellNib = [UINib nibWithNibName:kNibRssCell bundle:nil];
    [self.tableViewRSS registerNib:cellNib forCellReuseIdentifier:kRSSCell];
    self.tableViewRSS.estimatedRowHeight = 100;
    self.tableViewRSS.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableViewRSS setDelegate:self];
    [self.tableViewRSS setDataSource:self];
    
    
}

-(void) configureSearch

{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.tableViewRSS.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    
}

-(void)loadData
{
    feeds = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:kBaseURLRSS];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    BOOL result = [parser parse];
    
    if (!result)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                            message:NSLocalizedString(@"No se pueden actualizar datos", @"No se pueden actualizar datos")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
        
        
        
        [alertView show];
        
        NSData *serializeda = [[NSUserDefaults standardUserDefaults] objectForKey:@"feeds"];
        NSMutableArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:serializeda];
        
        feeds = myArray;
        
        if (feeds.count>0)
        {
            _tableViewRSS.hidden = false;
            [self registerTableView];
            
        }
        else
        {
            _tableViewRSS.hidden = true;
            
        }
        
    }
    else
    {
        _tableViewRSS.hidden = false;
        // en el caso de tener datos . cargamos la tabla.
        [self registerTableView];
        
    }
    
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.searchController.isActive && self.searchController.searchBar.text.length > 0) {
        return self.searchResults.count;
    }
    else {
        return feeds.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // RSSTableViewCell * cell = [_tableViewRSS dequeueReusableCellWithIdentifier:@"RSSCell" ];
    
    
    RSSTableViewCell * cell = [_tableViewRSS dequeueReusableCellWithIdentifier:kRSSCell forIndexPath:indexPath];
    Noticia * datos ;
    
    
    if (self.searchController.isActive && (![self.searchController.searchBar.text isEqualToString:@""])) {
        datos =(Noticia *) [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        datos= (Noticia *)[feeds objectAtIndex:indexPath.row];
    }
    
    
    
    cell.titulo.text =datos.titulo;
    cell.descripcion.text = datos.descripcion;
    
    cell.imagen.image  = [UIImage imageWithData:[datos getImagen] ];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:kSegueDetail sender:nil];
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

#pragma mark - PARSER


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        
        NSString *linkT =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [link appendString:linkT];
    }else if ([element isEqualToString:@"description"]) {
        
        NSString * result= [RSSUtils firstImgUrlString:string];
        
        if (result)
        {
            [image appendString:result];
            
        }
        
        NSString *stringWithoutHTML =
        [RSSUtils stringByStrippingHTML:string];
        
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
    
    
    
    // [self.tableViewRSS reloadData];
    if (feeds.count>0)
        
    {
        NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:feeds];
        [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:@"feeds"];
        
        
    }
    
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableViewRSS indexPathForSelectedRow];
    Noticia * datos ;
    
    if (self.searchController.isActive && (![self.searchController.searchBar.text isEqualToString:@""])) {
        datos =(Noticia *) [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        datos= (Noticia *)[feeds objectAtIndex:indexPath.row];
    }
    
    
    
    if([segue.identifier isEqualToString:@"detail"]){
        RssDetailViewController *VC = (RssDetailViewController*)segue.destinationViewController;
        
        
        
        VC.noticia = datos;
    }
}

#pragma mark - Getters / Setters

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

- (NSArray *)searchResults {
    NSString *searchString = [self.searchController.searchBar.text uppercaseString];
    NSMutableArray *array= [feeds mutableCopy] ;
    [array filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Noticia *customObject=(Noticia *) evaluatedObject;
        
        
        return ([customObject.titulo.uppercaseString containsString:searchString]);
    }]];
    
    return array;
    
    
}
#pragma mark - UISearchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    [self.tableViewRSS
     reloadData];
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}
@end
