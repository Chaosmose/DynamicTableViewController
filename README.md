# DynamicTableViewController
Table View cell configuration + automatic cells heights computation based on autolayout

DynamicTableViewController configurates automatically TableView Cells that implements the DynamicConfigurableCell protocol.
It means you donnot need to implement the UITableViewDataSource cellForRowAtIndexPath and cells heights are automatically computed. 
``` objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
```
Your tableview controller should implement the The DynamicTable protocol

``` objective-c
- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
- (NSObject<DynamicCellDataSource>*)cellDataSourceForIndexPath:(NSIndexPath*)indexPath;
 ```
And your cell should implement the DynamicConfigurableCell protocol.
``` objective-c
-(void)configureWith:(NSObject<DynamicCellDataSource>*)dataSource;
```
This approach allows to encapsulate the Cell logic.
When using autolayout & size class, the cells height is computed automatically.
 
## IMPORTANT Note on IOS7 

On ios7 to support Autoresizing height computation with full autolayout & classes sizes.
*You must* pass the preferredMaxLayoutWidth to any Multiline Label.
``` objective-c
self.myLabel.preferredMaxLayoutWidth=configurator.maxTextWidth;
```
preferredMaxLayoutWidth is required to support constraint-based layout (auto layout)
If nonzero, this is used when determining -intrinsicContentSize for multiline labels.

## How to mix Dynamic and non-dynamic cells?
 
 You should implement DynamicTable and  UITableViewDelegate row height and cells methods.
 Don't forget to call super after your implementation.
 
 ``` objective-c
 - (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
 	// Return the identifiers for the dynamic cells
 	if(indexPath.section==0){
 		return @"MyCellIdentifier";
 	}
 	...
 	return [super  cellIdentifierForIndexPath:indexPath];
 }
 
 - (NSObject<DynamicCellDataSource>*)cellDataSourceForIndexPath:(NSIndexPath*)indexPath;
		 // Return the datasources for the dynamic cells
		 if(indexPath.section==0){
			 ...
 			return theCellDataSource;
 			}
 		...
 		return [super  cellDataSourceForIndexPath:indexPath]; 
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 		// Manual cells ;
 		if(indexPath.section==0){
 			return 50.f;
		}
 		// Dynamic cells;
 		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
 }
 
 - (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 		if(indexPath.section==0){
 			...
 		}
 		...
 		return [super tableView:tableView cellForRowAtIndexPath:index];
 }
 ```
 
 
