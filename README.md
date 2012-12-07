PaginatedTableView
==================

PaginatedTableView

PaginatedTableview is a subclass of  UITableview that can be used in an app to implement pagination in a tableview.

To achieve that, either copy the files PaginatedTableView.h and PaginatedTableView.m into your project and add to targets.
Import and extend the class PagenatedTableView in the class which you want to use the Pagination technique. As this is an extension to the UITableView, it supports all the methods provided by UITableView. There are a few extra methods which you need to get the pagination functionality. They are:
-(void)setNumberOfRecordsPerPage:(int)count where the count is the maximum number of records per page, if nothing os set a value of 30 is taken as default records per page. 
-(void)setFirstPageData:(NSArray *)array where the array is an object of NSArray which has the details to display the first page as per implemented in - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath in your code
-(void)setNextPageData:(NSArray *)array where the array is an object of NSArray which has the details to display the page after the last page till now as per implemented in - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath in your code
-(void)getNextPageData This is a delegate method which is called when the last row in the last page is about to be displayed. You will need to use the method -(void)setNextPageData:(NSArray *)array to send the data required to display the next page. The -(void)setNextPageData:(NSArray *)array method need not be called in the -(void)getNextPageData method. It can be called in any other like in connectionDidFinishLoading if you use an asynchronous web request.
-(void)reset This method is used to clear all the values like the page count etc.

As you provide the class with count and arrays to display the pages, you need not implement - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView and - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section. Even if you implement those, they  won't make any affect on the way it acts.

Future Plans:

Allow the user to specify number of sections and number of rows.