#import "FlutterJdKeplerPlugin.h"
#import <JDKeplerSDK/JDKeplerSDK.h>

@implementation FlutterJdKeplerPlugin {
  UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_jd_kepler"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController =
      [UIApplication sharedApplication].delegate.window.rootViewController;

  FlutterJdKeplerPlugin* instance = [[FlutterJdKeplerPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    _viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    [self init:call result: result];
  } else if ([@"isLogin" isEqualToString:call.method]) {
    [self checkLogin:call result: result];
  } else if ([@"login" isEqualToString:call.method]) {
    [self login:call result: result];
  } else if ([@"logout" isEqualToString:call.method]) {
    [self logout:call result: result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *appKey = call.arguments[@"appKey"];
  NSString *appSecret = call.arguments[@"appSecret"];

  [[KeplerApiManager sharedKPService]asyncInitSdk:appKey
                                        secretKey:appSecret
                                    sucessCallback:^(){
    result(@(YES));
  }failedCallback:^(NSError *error){
    NSLog(@"Jd kepler error: %@",error);
    result(@(NO));
  }];
}


- (void)checkLogin:(FlutterMethodCall *)call result:(FlutterResult)result {
  [[KeplerApiManager sharedKPService] keplerLoginWithSuccess:^{
    result(@(YES));
  } failure:^{
    result(@(NO));
  }];
}

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
  [[KeplerApiManager sharedKPService] keplerLoginWithViewController:_viewController success:^{
    result(@(YES));
  } failure:^(NSError *error) {
    result(@(NO));
  }];
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
  [[KeplerApiManager sharedKPService] cancelAuth];
  result(@(YES));
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [[KeplerApiManager sharedKPService] handleOpenURL:url];
}

@end

