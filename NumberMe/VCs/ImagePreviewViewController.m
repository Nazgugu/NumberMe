//
//  ImagePreviewViewController.m
//  NumberMe
//
//  Created by Liu Zhe on 15/9/27.
//  Copyright © 2015年 Liu Zhe. All rights reserved.
//

#import "ImagePreviewViewController.h"

@interface ImagePreviewViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, strong) UIImage *theImage;

@end

@implementation ImagePreviewViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.theImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundImage setImage:_theImage];
//    if (_backgroundImage.image)
//    {
//        NSLog(@"in did load has image");
//    }
//    else
//    {
//        NSLog(@"no image in did load");
//    }
    // Do any additional setup after loading the view from its nib.
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
