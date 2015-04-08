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


#import <UIKit/UIKit.h>



/**
 *  The cell datasource informal protocol
 */
@protocol DynamicCellDataSource
@end

/**
 *  Any cell should conform to DynamicConfigurableCell
 */
@protocol DynamicConfigurableCell
@required
-(void)configureWith:(id<DynamicCellDataSource>)dataSource;
@end

/**
 *  The DynamicTable protocol
 */
@protocol DynamicTable 
@required
- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
- (id<DynamicCellDataSource>)cellDataSourceForIndexPath:(NSIndexPath*)indexPath;
@end


/**
 *  Your dynamic table view controller should implement DynamicTable
 *  and inheritate from DynamicTableViewController
 */
@interface DynamicTableViewController : UITableViewController<DynamicTable>
- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
- (id<DynamicCellDataSource>)cellDataSourceForIndexPath:(NSIndexPath*)indexPath;
@end