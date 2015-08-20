//
//  SettingViewController.m
//  
//
//  Created by Liu Zhe on 15/8/19.
//
//

#import "SettingViewController.h"
#import "EGOCache.h"

#define Setting_TitileArray @[@[NSLocalizedString(@"MAXNORMAL",nil),NSLocalizedString(@"MAXINFINITY",nil),NSLocalizedString(@"CLEARCACHE",nil)],@[NSLocalizedString(@"RATE",nil),NSLocalizedString(@"RECOMMEND",nil),NSLocalizedString(@"CONTACT",nil),NSLocalizedString(@"VERSION",nil)]]

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *settingTable;

@end

@implementation SettingViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self)
    {
        [_backgroundImage setImage:image];
        //_settingTable.backgroundColor = [UIColor clearColor];
        //_settingTable.backgroundView.backgroundColor = [UIColor clearColor];
        _settingTable.delegate = self;
        _settingTable.dataSource = self;
        [self setNavigationBarStyle];
        self.title = NSLocalizedString(@"STITLE", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.settingTable reloadData];
}

- (void)setNavigationBarStyle
{
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBarTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[UIColor whiteColor] colorWithAlphaComponent:0.8f], NSForegroundColorAttributeName, [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f], NSFontAttributeName,nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 4;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"SCTITLE1", nil);
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"SCTITLE2", nil);
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingCell"];
    }
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    cell.textLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    cell.detailTextLabel.textColor = [UIColor lightTextColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Book" size:16.0f];
    cell.textLabel.text = Setting_TitileArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                if ([[EGOCache globalCache] hasCacheForKey:@"maxNormalScore"])
                {
                    cell.detailTextLabel.text = [[EGOCache globalCache] stringForKey:@"maxNormalScore"];
                }
                else
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"NORECORD", nil);
                }
            }
                break;
            case 1:
            {
                if ([[EGOCache globalCache] hasCacheForKey:@"maxInfinityScore"])
                {
                    cell.detailTextLabel.text = [[EGOCache globalCache] stringForKey:@"maxInfinityScore"];
                }
                else
                {
                    cell.detailTextLabel.text = NSLocalizedString(@"NORECORD", nil);
                }
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 3)
        {
            cell.detailTextLabel.text = @"V 1.1";
        }
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
