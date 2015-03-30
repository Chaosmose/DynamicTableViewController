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

#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#import "DynamicTableViewController.h"

#define kDefaultCellHeight 50.f


@interface DynamicTableViewController (){
    BOOL _ios7;
    // Used for IOS 7 only
    NSMutableDictionary*_cellsForSizeComputionCache;
    NSMutableDictionary*_cellsHeightsCache;
}
@end

@implementation DynamicTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _ios7=SYSTEM_VERSION_LESS_THAN(@"8.0");
    if (_ios7) {
        _cellsForSizeComputionCache=[NSMutableDictionary dictionary];
        _cellsHeightsCache=[NSMutableDictionary dictionary];
    }else{
        self.tableView.estimatedRowHeight = 200.f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
}


#pragma mark - UITableViewDataSource dynamic cell configuration


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self )
        return [self _tableView:tableView configurableCellForRowAtIndexPath:indexPath];
}

- (UITableViewCell<DynamicConfigurableCell>*)_tableView:(UITableView *)tableView configurableCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =nil;
    NSString*cellIdentifier=[self cellIdentifierForIndexPath:indexPath];
    if(cellIdentifier){
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                               forIndexPath:indexPath];
        if([cell conformsToProtocol:@protocol(DynamicConfigurableCell)]){
            NSObject<DynamicCellDataSource>*cellDataSource=[self cellDataSourceForIndexPath:indexPath];
            if(cellDataSource){
                [(UITableViewCell<DynamicConfigurableCell>*)cell configureWith:cellDataSource];
            }
        }
    }
    return (UITableViewCell<DynamicConfigurableCell>*)cell;
}



#pragma mark - Autoresizing height computation


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_ios7) {
        return UITableViewAutomaticDimension;
    }else{
        NSNumber*cachedHeight=[_cellsHeightsCache objectForKey:[self _keyForRowAtIndexPath:indexPath]];
        if(cachedHeight){
            return [cachedHeight floatValue];
        }
        
        NSString*cellIdentifier=[self cellIdentifierForIndexPath:indexPath];
        if(cellIdentifier){
            UITableViewCell*cell=[_cellsForSizeComputionCache objectForKey:cellIdentifier];
            if(!cell){
                cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                [_cellsForSizeComputionCache setObject:cell
                                                forKey:cellIdentifier];
            }
            
            NSObject<DynamicCellDataSource>*cellDataSource=[self cellDataSourceForIndexPath:indexPath];
            if( [cell conformsToProtocol:@protocol(DynamicConfigurableCell)]){
                [(UITableViewCell<DynamicConfigurableCell>*)cell configureWith:cellDataSource];
            }
            
            // Make sure the constraints have been added to this cell
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            // Compute the size
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            height += 1.f;
            // Store the height
            [_cellsHeightsCache setObject:@(height)
                                   forKey:[self _keyForRowAtIndexPath:indexPath]];
            return height;
            
        }
        return kDefaultCellHeight;
    }
}



- (NSString*)_keyForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NSString stringWithFormat:@"%@|%@",@(indexPath.section),@(indexPath.row)];
}


#pragma mark - Abstract methods


// Those method should be implemented by DynamicTable

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    [NSException raise:@"DynamicTableViewController" format:@"DynamicTableViewController should conform to DynamicTable protocol @selector(cellIdentifierForIndexPath:)"];
    return nil;
}

- (NSObject<DynamicCellDataSource>*)cellDataSourceForIndexPath:(NSIndexPath*)indexPath{
    [NSException raise:@"DynamicTableViewController" format:@"DynamicTableViewController should conform to DynamicTable protocol @selector(cellDataSourceForIndexPath:)"];
    return nil;
}

@end