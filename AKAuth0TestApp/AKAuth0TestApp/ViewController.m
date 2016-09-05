//
//  ViewController.m
//  AKAuth0TestApp
//

#import "ViewController.h"
#import <Lock/Lock.h>

@interface ViewController ()

- (IBAction)clickOpenLockUIButton:(id)sender;
@end

@implementation ViewController

- (IBAction)clickOpenLockUIButton:(id)sender {
    A0Lock *lock = [A0Lock sharedLock];
    
    A0LockViewController *controller = [lock newLockViewController];
    controller.closable = YES;
    controller.onAuthenticationBlock = ^(A0UserProfile *profile, A0Token *token) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:controller animated:YES completion:nil];
}
@end
