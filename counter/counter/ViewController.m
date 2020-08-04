//
//  ViewController.m
//  counter
//
//  Created by 张毅成 on 2020/8/4.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ZYCTool.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;
@property (assign, nonatomic) NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@end

@implementation ViewController

- (NSMutableArray *)array {
    if (!_array) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *array = [user objectForKey:@"data"];
        NSArray *arrayTmp = [[array reverseObjectEnumerator] allObjects];
        _array = [NSMutableArray arrayWithArray:arrayTmp];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (IBAction)didTouchButtonAdd:(id)sender {
    self.count ++;
    self.labelCount.text = @(self.count).stringValue;
    NSMutableDictionary *dic = @{}.mutableCopy;
    dic[@"time"] = [self getCurrentTimes];
//    [self.array addObject:dic];
    [self.array insertObject:dic atIndex:0];
    NSLog(@"%@",self.array);
    [self.tableView reloadData];
    NSArray *array = [NSArray arrayWithArray:self.array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:array forKey:@"data"];
    
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [self.tableView scrollsToTop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary *dic = self.array[indexPath.row];
    cell.labelCount.text = @(self.array.count - indexPath.row + 5).stringValue;
    cell.labelTime.text = dic[@"time"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [ZYCTool alertControllerTwoButtonWithTitle:@"确认删除？" message:@"删除后将不可恢复" target:self notarizeButtonTitle:nil cancelButtonTitle:nil notarizeAction:^{
        [self.array removeObjectAtIndex:indexPath.row];
        NSLog(@"%lu", (unsigned long)self.array.count);
        NSArray *array = [NSArray arrayWithArray:self.array];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:array forKey:@"data"];
        self.count --;
        [self.tableView reloadData];
        } cancelAction:^{
            
        }];
}

- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
//    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
}

@end

