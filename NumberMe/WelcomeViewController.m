//
//  WelcomeViewController.m
//  
//
//  Created by Liu Zhe on 15/8/2.
//
//

#import "WelcomeViewController.h"
#import "GameViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //setting up button appearance
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _startButton.layer.borderWidth = 1.0f;
    _settingButton.layer.borderWidth = 1.0f;
    _recordButton.layer.borderWidth = 1.0f;
    _startButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _recordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _settingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _startButton.layer.cornerRadius = 15.0f;
    _recordButton.layer.cornerRadius = 15.0f;
    _settingButton.layer.cornerRadius = 15.0f;
    _settingButton.layer.masksToBounds = YES;
    _recordButton.layer.masksToBounds = YES;
    _startButton.layer.masksToBounds = YES;
}

- (IBAction)startGame:(id)sender {
    GameViewController *gameVC = [[GameViewController alloc] init];
    [self presentViewController:gameVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
