//
//  WelcomeVC.m
//  ARFurniture
//
//  Created by ThanhSon on 7/25/18.
//  Copyright © 2018 ThanhSon. All rights reserved.
//

#import "WelcomeVC.h"
#import "MainController.h"
#import "SMTransition.h"

@interface WelcomeVC () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SMTransition *transition;

@property (nonatomic, weak) IBOutlet UIScrollView *scrContent;
@property (nonatomic, weak) IBOutlet UIView *vWelcome0;
@property (nonatomic, weak) IBOutlet UIView *vWelcome1;
@property (nonatomic, weak) IBOutlet UIView *vWelcome2;
@property (nonatomic, weak) IBOutlet UIImageView *imvWelcome;
@property (nonatomic, weak) IBOutlet UIPageControl *pageView;
@property (nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *imvWelcome0;
@property (weak, nonatomic) IBOutlet UIImageView *imvWelcome1;
@property (weak, nonatomic) IBOutlet UIImageView *imvWelcome2;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome0;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome1;
@property (weak, nonatomic) IBOutlet UILabel *lblWelcome2;

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL isPause;

@end



@implementation WelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
}

#pragma mark - initScrollView

- (void)initScrollView {
    _index = 0;
    UIView *viewFade = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_scrContent.frame.size.width *3 , _scrContent.frame.size.height)];
    viewFade.backgroundColor = [UIColor blackColor];
    viewFade.alpha = 0.3;
    
    [_vWelcome0 setFrame:CGRectMake(_scrContent.frame.size.width*0, 0 ,_scrContent.frame.size.width , _scrContent.frame.size.height)];
    [_vWelcome1 setFrame:CGRectMake(_scrContent.frame.size.width*1, 0,_scrContent.frame.size.width , _scrContent.frame.size.height)];
    [_vWelcome2 setFrame:CGRectMake(_scrContent.frame.size.width*2, 0,_scrContent.frame.size.width , _scrContent.frame.size.height)];
    [_imvWelcome setFrame:CGRectMake(0, 0,_scrContent.frame.size.width *3 , _scrContent.frame.size.height)];
    
    [_scrContent addSubview:_imvWelcome];
    [_scrContent addSubview:viewFade];
    [_scrContent addSubview:_vWelcome0];
    [_scrContent addSubview:_vWelcome1];
    [_scrContent addSubview:_vWelcome2];
    
    _scrContent.contentSize = CGSizeMake(_scrContent.frame.size.width *3, _scrContent.frame.size.height);
    
    _timer= [NSTimer scheduledTimerWithTimeInterval:2
                                             target:self
                                           selector:@selector(onTimer)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)onTimer {
    if (!_isPause) {
        CGFloat w = _scrContent.frame.size.width;
        NSInteger scrollIndex  = (_scrContent.contentOffset.x + w/2) / w;
        NSLog(@"%ld",scrollIndex);
        if(scrollIndex == 2) {
            scrollIndex = 0;
        } else {
            scrollIndex++;
        }
        _index = scrollIndex;
        
        [_scrContent setContentOffset:CGPointMake(scrollIndex*_scrContent.frame.size.width, _scrContent.contentOffset.y) animated:YES];
        
        _pageView.currentPage = scrollIndex;
    }
}

- (void) updateUICarouel:(BOOL)hasUpdate {
    CGFloat w = _scrContent.frame.size.width;
    NSInteger scrollIndex  = (_scrContent.contentOffset.x + w/2) / w;
    NSLog(@"%ld",scrollIndex);
    if(scrollIndex > 2) {
        scrollIndex = 0;
    }
    _index = scrollIndex;
    
    if(hasUpdate) {
        [_scrContent setContentOffset:CGPointMake(scrollIndex*_scrContent.frame.size.width, _scrContent.contentOffset.y) animated:YES];
    }
    
    _pageView.currentPage = scrollIndex;

}


- (IBAction)btnLogin:(id)sender {
    _isPause = YES;
    MainController *vc = VCFromSB(MainController, SB_Main);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imvWelcome0.transform = CGAffineTransformScale(CGAffineTransformIdentity, 4, 4);
        self.imvWelcome1.transform = CGAffineTransformScale(CGAffineTransformIdentity, 4, 4);
        self.imvWelcome2.transform = CGAffineTransformScale(CGAffineTransformIdentity, 4, 4);
        self.lblWelcome0.alpha = 0;
        self.lblWelcome1.alpha = 0;
        self.lblWelcome2.alpha = 0;
        self.imvWelcome.alpha = 0.5;
    } completion:^(BOOL finished) {
        [AppNav popToRootAndSwitchToViewController:vc withSlideOutAnimation:YES
                                     andCompletion:^{
                                         self.imvWelcome.alpha = 1;
                                         self.imvWelcome0.transform = CGAffineTransformIdentity;
                                         self.imvWelcome1.transform = CGAffineTransformIdentity;
                                         self.imvWelcome2.transform = CGAffineTransformIdentity;
                                         self.lblWelcome0.alpha = 1;
                                         self.lblWelcome1.alpha = 1;
                                         self.lblWelcome2.alpha = 1;
                                     }];
    }];
}


#pragma mark - ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
     [self updateUICarouel:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(_timer) {
        if([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        _isPause = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateUICarouel:YES];
    if (_timer) {
        _isPause = NO;
    }
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    _transition = [[SMTransition alloc] init];
    _transition.isPresent = YES;
    
    return _transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return nil;
}



@end
