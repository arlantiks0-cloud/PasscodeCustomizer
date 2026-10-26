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

    // Проверяем, добавлена ли уже картинка фона, если нет — создаем UIImageView
    UIImageView *bgImageView = [self viewWithTag:8888];
    if (!bgImageView && customImagePath.length > 0) {
        bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.tag = 8888;
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.image = [UIImage imageWithContentsOfFile:customImagePath];
        // Вставляем картинку на самый задний план панели пароля
        [self insertSubview:bgImageView atIndex:0];
    } else if (customImagePath.length > 0) {
        bgImageView.image = [UIImage imageWithContentsOfFile:customImagePath];
    }
}
%end

// Функция оптимизации для уменьшения лагов (ускорение анимаций / снижение нагрузки)
%hook SBFluidSwitcherViewController
- (void)viewDidLoad {
    %orig;
    if (reduceLagEnabled) {
        // Убираем лишние тяжелые эффекты размытия в переключателе приложений
        self.view.alpha = 0.99; 
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
