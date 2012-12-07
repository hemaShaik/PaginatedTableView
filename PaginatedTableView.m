//
//  PaginatedTableView.m
//  PaginatedTableViewSample
//
//  Created by Hema Shaik on 05/12/12.
//  Copyright (c) 2012 Hema Shaik. All rights reserved.
//

#import "PaginatedTableView.h"
#import <objc/runtime.h>



@interface PaginatedTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PaginatedTableView
@synthesize dataArray;
@synthesize pageNumber;
@synthesize numberOFRecordsPerPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.numberOFRecordsPerPage=30;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self=[super initWithFrame:frame style:style];
    if(self){
        
        
        self.numberOFRecordsPerPage=30;
        
        
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.numberOFRecordsPerPage=30;
    }
    return self;
}
-(void)setFirstPageData:(NSArray *)array{
    
    self.pageNumber=1;
    dataArray=[[NSMutableArray alloc]init];
    
    [self.dataArray addObjectsFromArray:array];
}





-(void)getNextPageData{
   
    if ([_realDelegate respondsToSelector:@selector(getNextPageData)]){
        if([self.dataArray count]<self.numberOFRecordsPerPage){
            if(!nextPageRequest){
                nextPageRequest=YES;
                self.pageNumber=self.pageNumber+1;
                
                [self reloadData];
                [aiView startAnimating];
                
                [_realDataSource getNextPageData];
                
            }
        }
    }
    
}
-(void)setNextPageData:(NSArray *)array{
    if([array count] <self.numberOFRecordsPerPage)
        isLastPage=YES;
    
    [dataArray addObjectsFromArray:array];
    nextPageRequest=NO;
    [self reloadData];
    
    [aiView stopAnimating ];
    [aiView removeFromSuperview];
    
    
}

-(void)reset{
    isLastPage=NO;
    [dataArray removeAllObjects];
    pageNumber=1;
    [self reloadData];
    
}
-(void)setNumberOfRecordsPerPage:(int)count{
    self.numberOFRecordsPerPage=count;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [self.dataArray count]){
        
        if ([_realDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return  [_realDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
        else
            return 44;
        
    }else
        return 44;   //loader cell height
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"no of rows");
    // Return the number of rows in the section.
    if(nextPageRequest)
        return [self.dataArray count]+1;
    else
        return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == [dataArray count]){
        
        static NSString *CellIdentifier=@"LoaderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            aiView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            aiView.frame=CGRectMake(146, 10, 28, 28);
            
        }
        
        cell.textLabel.text=@"Loading...";
        [cell.contentView addSubview:aiView];
        [aiView startAnimating];
        cell.userInteractionEnabled = NO;
        
        
    }else
        cell = [_realDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    
    
    
    return cell;
}





#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if(indexPath.row == [dataArray count]-1  && !isLastPage){
        if(!nextPageRequest){
            [self getNextPageData];
        }
    }
    
    if ([_realDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [_realDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < [dataArray count]){
        
        if ([_realDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [_realDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
        
    }
}



#pragma mark -
#pragma mark Protocol/Message Forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL result = [super respondsToSelector:aSelector];
    
    /*
     * Check if the selector is part of the UITableViewDataSource protocol.
     */
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    
    if (dataSourceMethod.name != nil) {
        result = [_realDataSource respondsToSelector:aSelector]|| [super respondsToSelector:aSelector ]?YES:NO;
    }
    
    /*
     * Check if the selector is part of the UITableViewDelegate protocol.
     */
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    
    if (delegateMethod.name != nil) {
        result = [_realDelegate respondsToSelector:aSelector]|| [super respondsToSelector:aSelector ]?YES:NO;
    }
    
    return result;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    /*
     * Check if the selector is part of the UITableViewDataSource protocol.
     */
    
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), aSelector, NO, YES);
    
    if (dataSourceMethod.name != nil) {
        signature = [(NSObject *)_realDataSource methodSignatureForSelector:aSelector];
    }
    
    /*
     * Check if the selector is part of the UITableViewDelegate protocol.
     */
    
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), aSelector, NO, YES);
    
    if (delegateMethod.name != nil) {
        signature = [(NSObject *)_realDelegate methodSignatureForSelector:aSelector];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    struct objc_method_description dataSourceMethod = protocol_getMethodDescription(@protocol(UITableViewDataSource), selector, NO, YES);
    struct objc_method_description delegateMethod = protocol_getMethodDescription(@protocol(UITableViewDelegate), selector, NO, YES);
    
    /*
     * Route the invocation to the original data source, delegate, or super
     */
    
    if (dataSourceMethod.name != nil && [_realDataSource respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:_realDataSource];
    } else if (delegateMethod.name != nil && [_realDelegate respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:_realDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}




#pragma mark -
#pragma mark Overrides

- (void)setDataSource:(id <UITableViewDataSource>)dataSourceForward {
    _realDataSource = dataSourceForward;
    
    [super setDataSource:self];
}

- (void)setDelegate:(id <UITableViewDelegate>)delegateForward {
    _realDelegate = delegateForward;
    
    [super setDelegate:self];
}


@end
