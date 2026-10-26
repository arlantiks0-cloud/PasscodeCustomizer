#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>

static BOOL enabled;
static BOOL reduceLagEnabled;
static NSString *customImagePath;

// Хук на панель ввода пароля в SpringBoard
%hook SBUIPasscodeLockViewWithKeypad
- (void)layoutSubviews {
    %orig;
    if (!enabled) return;

    UIView *selfView = (UIView *)self;
    UIImageView *bgImageView = [selfView viewWithTag:8888];
    if (!bgImageView && customImagePath.length > 0) {
        bgImageView = [[UIImageView alloc] initWithFrame:selfView.bounds];
        bgImageView.tag = 8888;
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.image = [UIImage imageWithContentsOfFile:customImagePath];
        [selfView insertSubview:bgImageView atIndex:0];
    } else if (customImagePath.length > 0) {
        bgImageView.image = [UIImage imageWithContentsOfFile:customImagePath];
    }
}
%end

// Функция оптимизации для уменьшения лагов
%hook SBFluidSwitcherViewController
- (void)viewDidLoad {
    %orig;
    if (reduceLagEnabled) {
        UIViewController *selfVC = (UIViewController *)self;
        selfVC.view.alpha = 0.99; 
    }
}
%end

// Загрузка настроек через библиотеку Cephei
%ctor {
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier:@"com.yourname.passcodecustomizer"];
    [preferences registerBool:&enabled default:YES forKey:@"Enabled"];
    [preferences registerBool:&reduceLagEnabled default:YES forKey:@"ReduceLag"];
    [preferences registerObject:&customImagePath default:@"/var/mobile/Media/PasscodeBg.jpg" forKey:@"CustomImagePath"];
}
