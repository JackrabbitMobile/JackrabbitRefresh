//
//  JRRefreshControl.h
//  JackrabbitRefresh
//
//  Created by Jack_iMac on 15/3/29.
//  Copyright (c) 2015年 Jackrabbit Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRRefreshControl : UIRefreshControl

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
