#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>

@interface CSPasscodeViewController : UIViewController
@end

%hook CSPasscodeViewController

- (void)viewDidLoad {
    %orig;

    HBPreferences *prefs = [HBPreferences preferencesForIdentifier:@"com.f1lony.passcodecustomizer"];
    BOOL enabled = [prefs boolForKey:@"enabled" default:YES];
    
    if (!enabled) return;

    NSString *bgPath = [prefs objectForKey:@"bgPath"];
    if (!bgPath) {
        bgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/PasscodeBg.jpg"];
    }

    UIImage *bgImage = [UIImage imageWithContentsOfFile:bgPath];
    if (bgImage) {
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        bgView.image = bgImage;
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Вставляем картинку под самый нижний слой, чтобы она уходила за кнопки
        [self.view insertSubview:bgView atIndex:0];
    }
}

%end
