//
//  RssMainTableViewController.h
//  RSSReader
//
//  Created by Yago de Martin Lopez on 3/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RssMainTableViewController : UITableViewController <NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewRSS;


-(NSString *) stringByStrippingHTML ;

@end
