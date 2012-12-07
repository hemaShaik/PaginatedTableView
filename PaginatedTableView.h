//
//  PaginatedTableView.h
//  PaginatedTableViewSample
//
//  Created by Hema Shaik on 05/12/12.
//  Copyright (c) 2012 Hema Shaik. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PaginatedTableView : UITableView{
    
    BOOL nextPageRequest;
    BOOL isLastPage;
    BOOL numberOFRecordsPerPage;
    UIActivityIndicatorView *aiView;
    
    
    
    NSMutableArray *dataArray;
    int pageNumber;    
    id <UITableViewDataSource> _realDataSource;
    id <UITableViewDelegate> _realDelegate;
    //id delegate;
    
}
@property (nonatomic,assign) BOOL numberOFRecordsPerPage;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) id dataSource;
@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,readwrite) int pageNumber;

-(void)setFirstPageData:(NSArray *)array;
-(void)setNextPageData:(NSArray *)array;
-(void)getNextPageData;
-(void)setNumberOfRecordsPerPage:(int)count;
-(void)reset;
@end
