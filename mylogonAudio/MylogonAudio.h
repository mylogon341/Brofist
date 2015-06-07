
@interface MylogonAudio : NSObject

+ (instancetype)sharedInstance;

- (void)playDataBackgroundMusic:(NSData *)pffile;

- (void)playBackgroundMusic:(NSString *)filename;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;

- (void)playSoundEffect:(NSString *)filename;

@end
