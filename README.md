# DynamicTableViewController
'Table View cell configuration + automatic cells heights computation based on autolayout

DynamicTableViewController configurates automatically TableView Cells that implements the DynamicConfigurableCell protocol.
It means you donnot need to implement the UITableViewDataSource cellForRowAtIndexPath and cells heights are automatically computed. 
``` objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
```
Your tableview controller needs to implement the The DynamicTable protocol

``` objective-c
- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
- (NSObject<DynamicCellDataSource>*)cellDataSourceForIndexPath:(NSIndexPath*)indexPath;
 ```
And your cell must implement the DynamicConfigurableCell protocol.
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
