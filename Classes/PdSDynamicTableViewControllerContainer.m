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

#import "PdSDynamicTableViewControllerContainer.h"

#define kDefaultCellHeight 50.f


@interface PdSDynamicTableViewControllerContainer (){
    BOOL _ios7;
    // Used for IOS 7 only
    NSMutableDictionary*_cellsForSizeComputation;
}

@end

@implementation PdSDynamicTableViewControllerContainer


-(void)viewDidLoad{
    [super viewDidLoad];
    _ios7=SYSTEM_VERSION_LESS_THAN(@"8.0");
    if (_ios7) {
        _cellsForSizeComputation=[NSMutableDictionary dictionary];
    }else{
        self.tableView.estimatedRowHeight = 200.f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    _cellsForSizeComputation=nil;
}

#pragma mark - UITableViewDataSource dynamic cell configuration


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



#pragma mark - Autoresizing height computation

// Remember that you can disable this behaviour by implementing this method in your class.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*cellIdentifier=[self cellIdentifierForIndexPath:indexPath];
    if (!_ios7 && cellIdentifier){
        return UITableViewAutomaticDimension;
    }else{
        // In various situation caching the size is not possible.
        // We do use one cell per cell identifier
        // And recompute the height on each demand.
        if(cellIdentifier){
            UITableViewCell*cell=[_cellsForSizeComputation objectForKey:cellIdentifier];
            if(!cell){
                cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // Make sure the constraints have been added to this cell
                [cell setNeedsUpdateConstraints];
                [cell updateConstraintsIfNeeded];
                [_cellsForSizeComputation setObject:cell
                                             forKey:cellIdentifier];
            }
            id<DynamicCellDataSource>cellDataSource=[self cellDataSourceForIndexPath:indexPath];
            if( [cell conformsToProtocol:@protocol(DynamicConfigurableCell)]){
                [(UITableViewCell<DynamicConfigurableCell>*)cell configureWith:cellDataSource];
            }
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            height += 1.f;
            return height;
        }
    }
    return kDefaultCellHeight;
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

@end