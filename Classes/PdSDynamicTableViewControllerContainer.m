//
// DynamicTableViewController.h
//
// Copyright (c) 2015 Benoit Pereira da Silva (http://pereira-da-silva.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "PdSDynamicTableViewControllerContainer.h"



@interface PdSDynamicTableViewControllerContainer (){
}

@end

@implementation PdSDynamicTableViewControllerContainer


-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark - Autoresizing height computation

// Remember that you can disable this behaviour by implementing this method in your class.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSString*)_keyForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NSString stringWithFormat:@"%@|%@",@(indexPath.section),@(indexPath.row)];
}


#pragma mark - Default implementation

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    return nil;
}

- (id<DynamicCellDataSource>*)cellDataSourceForIndexPath:(NSIndexPath*)indexPath{
    return nil;
}

#pragma mark - UITableViewDataSource


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*cellIdentifier=[self cellIdentifierForIndexPath:indexPath];
    if(cellIdentifier){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                     forIndexPath:indexPath];
        if([cell conformsToProtocol:@protocol(DynamicConfigurableCell)]){
            id<DynamicCellDataSource>cellDataSource=[self cellDataSourceForIndexPath:indexPath];
            if(cellDataSource){
                [(UITableViewCell<DynamicConfigurableCell>*)cell configureWith:cellDataSource];
            }
            return cell;
        }
    }
    [NSException raise:@"DynamicTableViewController"
                format:@"This cell should not be nil cellIdentifier:\"%@\" section:%@ row:%@ if you mix dynamic & non dynamic cells please check the readme file instructions",cellIdentifier?cellIdentifier:@"",@(indexPath.section),@(indexPath.row)];
    return nil;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
@end
