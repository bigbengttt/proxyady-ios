#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BIButton : UIButton
+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color;
@end

@implementation BIButton
+ (instancetype)buttonWithTitle:(NSString *)title color:(UIColor *)color {
    BIButton *b = [BIButton buttonWithType:UIButtonTypeSystem];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBlack];
    b.backgroundColor = color;
    b.layer.cornerRadius = 12;
    b.layer.shadowColor = color.CGColor;
    b.layer.shadowRadius = 12;
    b.layer.shadowOpacity = 0.65;
    b.layer.shadowOffset = CGSizeZero;
    return b;
}
@end

@interface CharacterFactory : NSObject
+ (SCNNode *)hero:(UIColor *)color;
+ (SCNNode *)bot:(UIColor *)color;
+ (SCNNode *)tree;
+ (SCNNode *)house;
+ (SCNNode *)loot;
@end

@implementation CharacterFactory
+ (SCNNode *)boxW:(CGFloat)w h:(CGFloat)h l:(CGFloat)l color:(UIColor *)color {
    SCNBox *g = [SCNBox boxWithWidth:w height:h length:l chamferRadius:0.04];
    g.firstMaterial.diffuse.contents = color;
    return [SCNNode nodeWithGeometry:g];
}
+ (SCNNode *)cylinder:(CGFloat)r h:(CGFloat)h color:(UIColor *)color {
    SCNCylinder *g = [SCNCylinder cylinderWithRadius:r height:h];
    g.firstMaterial.diffuse.contents = color;
    return [SCNNode nodeWithGeometry:g];
}
+ (SCNNode *)sphere:(CGFloat)r color:(UIColor *)color {
    SCNSphere *g = [SCNSphere sphereWithRadius:r];
    g.firstMaterial.diffuse.contents = color;
    return [SCNNode nodeWithGeometry:g];
}
+ (SCNNode *)hero:(UIColor *)color {
    SCNNode *root = [SCNNode node];

    SCNNode *body = [self cylinder:0.32 h:1.15 color:color];
    body.position = SCNVector3Make(0, 0.95, 0);
    [root addChildNode:body];

    SCNNode *head = [self sphere:0.25 color:[UIColor colorWithRed:0.70 green:0.48 blue:0.32 alpha:1]];
    head.position = SCNVector3Make(0, 1.68, 0);
    [root addChildNode:head];

    SCNNode *bag = [self boxW:0.55 h:0.70 l:0.22 color:[UIColor colorWithRed:0.05 green:0.18 blue:0.10 alpha:1]];
    bag.position = SCNVector3Make(0, 1.05, 0.36);
    [root addChildNode:bag];

    SCNNode *gun = [self boxW:0.12 h:0.12 l:0.90 color:UIColor.blackColor];
    gun.position = SCNVector3Make(0.38, 1.05, -0.35);
    gun.eulerAngles = SCNVector3Make(0.15, 0, 0);
    [root addChildNode:gun];

    SCNNode *l1 = [self cylinder:0.12 h:0.70 color:UIColor.darkGrayColor];
    l1.position = SCNVector3Make(-0.15, 0.34, 0);
    [root addChildNode:l1];

    SCNNode *l2 = [self cylinder:0.12 h:0.70 color:UIColor.darkGrayColor];
    l2.position = SCNVector3Make(0.15, 0.34, 0);
    [root addChildNode:l2];

    return root;
}
+ (SCNNode *)bot:(UIColor *)color {
    SCNNode *n = [self hero:color];
    n.scale = SCNVector3Make(0.82,0.82,0.82);
    return n;
}
+ (SCNNode *)tree {
    SCNNode *root = [SCNNode node];

    SCNNode *trunk = [self cylinder:0.10 h:1.1 color:[UIColor colorWithRed:0.28 green:0.15 blue:0.07 alpha:1]];
    trunk.position = SCNVector3Make(0,0.55,0);
    [root addChildNode:trunk];

    SCNCone *cone = [SCNCone coneWithTopRadius:0.03 bottomRadius:0.70 height:1.8];
    cone.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.04 green:0.25 blue:0.08 alpha:1];
    SCNNode *leaves = [SCNNode nodeWithGeometry:cone];
    leaves.position = SCNVector3Make(0,1.75,0);
    [root addChildNode:leaves];

    return root;
}
+ (SCNNode *)house {
    SCNNode *root = [SCNNode node];

    SCNNode *base = [self boxW:2.8 h:1.6 l:2.8 color:[UIColor colorWithRed:0.48 green:0.34 blue:0.23 alpha:1]];
    base.position = SCNVector3Make(0,0.8,0);
    [root addChildNode:base];

    SCNCone *roofGeo = [SCNCone coneWithTopRadius:0 bottomRadius:2.25 height:1.1];
    roofGeo.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.35 green:0.12 blue:0.07 alpha:1];
    SCNNode *roof = [SCNNode nodeWithGeometry:roofGeo];
    roof.position = SCNVector3Make(0,2.05,0);
    roof.scale = SCNVector3Make(1,1,0.75);
    [root addChildNode:roof];

    return root;
}
+ (SCNNode *)loot {
    SCNNode *n = [self boxW:0.55 h:0.35 l:0.55 color:[UIColor colorWithRed:0.95 green:0.20 blue:0.55 alpha:1]];
    n.name = @"loot";
    SCNAction *up = [SCNAction moveByX:0 y:0.22 z:0 duration:0.5];
    SCNAction *down = [SCNAction moveByX:0 y:-0.22 z:0 duration:0.5];
    [n runAction:[SCNAction repeatActionForever:[SCNAction sequence:@[up,down]]]];
    return n;
}
@end

@interface GameVC : UIViewController
@property(nonatomic,strong) SCNView *scn;
@property(nonatomic,strong) SCNScene *scene;
@property(nonatomic,strong) SCNNode *player;
@property(nonatomic,strong) SCNNode *camera;
@property(nonatomic,strong) NSMutableArray<SCNNode *> *bots;
@property(nonatomic,strong) NSMutableArray<SCNNode *> *loots;
@property(nonatomic,strong) UILabel *aliveLabel;
@property(nonatomic,strong) UILabel *killsLabel;
@property(nonatomic,strong) UILabel *ammoLabel;
@property(nonatomic,strong) UIProgressView *hpBar;
@property(nonatomic,strong) CADisplayLink *link;
@property(nonatomic) CGPoint move;
@property(nonatomic) NSInteger alive;
@property(nonatomic) NSInteger kills;
@property(nonatomic) NSInteger ammo;
@property(nonatomic) CGFloat hp;
@property(nonatomic) CFTimeInterval last;
@end

@implementation GameVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.alive = 32;
    self.kills = 0;
    self.ammo = 30;
    self.hp = 1.0;
    self.bots = NSMutableArray.array;
    self.loots = NSMutableArray.array;

    self.scene = [SCNScene scene];

    self.scn = [[SCNView alloc] initWithFrame:self.view.bounds];
    self.scn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scn.scene = self.scene;
    self.scn.backgroundColor = [UIColor colorWithRed:0.45 green:0.72 blue:0.96 alpha:1];
    self.scn.playing = YES;
    self.scn.preferredFramesPerSecond = 60;
    [self.view addSubview:self.scn];

    [self buildWorld];
    [self buildHUD];

    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}

- (void)buildWorld {
    SCNNode *sun = [SCNNode node];
    sun.light = [SCNLight light];
    sun.light.type = SCNLightTypeDirectional;
    sun.light.intensity = 1200;
    sun.eulerAngles = SCNVector3Make(-0.85,0.45,0);
    [self.scene.rootNode addChildNode:sun];

    SCNFloor *floor = [SCNFloor floor];
    floor.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.28 green:0.58 blue:0.27 alpha:1];
    SCNNode *floorNode = [SCNNode nodeWithGeometry:floor];
    [self.scene.rootNode addChildNode:floorNode];

    [self addRoadX:0 z:0 rot:0.24 w:5 l:95 color:UIColor.darkGrayColor];
    [self addRoadX:-12 z:4 rot:-1.05 w:4 l:60 color:UIColor.grayColor];

    for (NSInteger i=0;i<85;i++) {
        SCNNode *t = [CharacterFactory tree];
        t.position = SCNVector3Make([self rnd:-42 b:42],0,[self rnd:-42 b:42]);
        [self.scene.rootNode addChildNode:t];
    }

    for (NSInteger i=0;i<28;i++) {
        SCNNode *h = [CharacterFactory house];
        h.position = SCNVector3Make([self rnd:-38 b:38],0,[self rnd:-38 b:38]);
        h.eulerAngles = SCNVector3Make(0,[self rnd:0 b:6.28],0);
        [self.scene.rootNode addChildNode:h];
    }

    self.player = [CharacterFactory hero:UIColor.yellowColor];
    self.player.position = SCNVector3Make(0,0.05,0);
    [self.scene.rootNode addChildNode:self.player];

    self.camera = [SCNNode node];
    self.camera.camera = [SCNCamera camera];
    self.camera.camera.fieldOfView = 62;
    self.camera.position = SCNVector3Make(0,6,9);
    [self.scene.rootNode addChildNode:self.camera];
    self.scn.pointOfView = self.camera;

    for (NSInteger i=0;i<31;i++) {
        UIColor *c = @[
            UIColor.redColor, UIColor.orangeColor, UIColor.purpleColor,
            UIColor.cyanColor, UIColor.magentaColor, UIColor.brownColor
        ][i%6];
        SCNNode *b = [CharacterFactory bot:c];
        b.position = SCNVector3Make([self rnd:-35 b:35],0.05,[self rnd:-35 b:35]);
        [self.bots addObject:b];
        [self.scene.rootNode addChildNode:b];
    }

    for (NSInteger i=0;i<42;i++) {
        SCNNode *l = [CharacterFactory loot];
        l.position = SCNVector3Make([self rnd:-36 b:36],0.35,[self rnd:-36 b:36]);
        [self.loots addObject:l];
        [self.scene.rootNode addChildNode:l];
    }

    SCNTorus *zone = [SCNTorus torusWithRingRadius:42 pipeRadius:0.06];
    zone.firstMaterial.diffuse.contents = [UIColor cyanColor];
    SCNNode *zoneNode = [SCNNode nodeWithGeometry:zone];
    zoneNode.position = SCNVector3Make(0,0.12,0);
    zoneNode.eulerAngles = SCNVector3Make(M_PI_2,0,0);
    [self.scene.rootNode addChildNode:zoneNode];
    [zoneNode runAction:[SCNAction scaleTo:0.20 duration:140]];
}

- (void)addRoadX:(CGFloat)x z:(CGFloat)z rot:(CGFloat)rot w:(CGFloat)w l:(CGFloat)l color:(UIColor *)color {
    SCNBox *geo = [SCNBox boxWithWidth:w height:0.04 length:l chamferRadius:0.02];
    geo.firstMaterial.diffuse.contents = color;
    SCNNode *n = [SCNNode nodeWithGeometry:geo];
    n.position = SCNVector3Make(x,0.02,z);
    n.eulerAngles = SCNVector3Make(0,rot,0);
    [self.scene.rootNode addChildNode:n];
}

- (void)buildHUD {
    self.aliveLabel = [self label:@"VIVOS 32" color:UIColor.cyanColor x:14 y:55 w:105];
    self.killsLabel = [self label:@"ABATES 0" color:UIColor.redColor x:self.view.bounds.size.width-125 y:55 w:110];
    self.killsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.ammoLabel = [self label:@"30/90\nAR" color:[UIColor colorWithWhite:0 alpha:0.55] x:self.view.bounds.size.width-115 y:120 w:100];
    self.ammoLabel.numberOfLines = 2;
    self.ammoLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    UILabel *zone = [[UILabel alloc] initWithFrame:CGRectMake(80,95,self.view.bounds.size.width-160,34)];
    zone.text = @"⚠️ A zona segura irá diminuir 01:23";
    zone.textColor = UIColor.whiteColor;
    zone.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBlack];
    zone.textAlignment = NSTextAlignmentCenter;
    zone.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    zone.layer.cornerRadius = 17;
    zone.clipsToBounds = YES;
    zone.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:zone];

    self.hpBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.hpBar.frame = CGRectMake(70,self.view.bounds.size.height-38,self.view.bounds.size.width-140,8);
    self.hpBar.progress = 1.0;
    self.hpBar.progressTintColor = UIColor.greenColor;
    self.hpBar.trackTintColor = [UIColor colorWithWhite:0 alpha:0.45];
    self.hpBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.hpBar];

    [self controlButton:@"🔫" x:self.view.bounds.size.width-95 y:self.view.bounds.size.height-140 sel:@selector(fire)];
    [self controlButton:@"↗" x:self.view.bounds.size.width-95 y:self.view.bounds.size.height-220 sel:@selector(jump)];
    [self controlButton:@"🎒" x:self.view.bounds.size.width-170 y:self.view.bounds.size.height-160 sel:@selector(openInventory)];
    [self controlButton:@"⬇" x:self.view.bounds.size.width-95 y:self.view.bounds.size.height-70 sel:@selector(crouch)];

    UIView *joy = [[UIView alloc] initWithFrame:CGRectMake(25,self.view.bounds.size.height-135,95,95)];
    joy.layer.cornerRadius = 47.5;
    joy.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
    joy.layer.borderWidth = 2;
    joy.backgroundColor = [UIColor colorWithWhite:0 alpha:0.20];
    joy.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:joy];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePan:)];
    [joy addGestureRecognizer:pan];
}

- (UILabel *)label:(NSString *)text color:(UIColor *)color x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x,y,w,38)];
    l.text = text;
    l.textColor = UIColor.whiteColor;
    l.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [color colorWithAlphaComponent:0.85];
    l.layer.cornerRadius = 8;
    l.clipsToBounds = YES;
    [self.view addSubview:l];
    return l;
}

- (UIButton *)controlButton:(NSString *)t x:(CGFloat)x y:(CGFloat)y sel:(SEL)sel {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(x,y,62,62);
    b.layer.cornerRadius = 31;
    b.backgroundColor = [UIColor colorWithWhite:0 alpha:0.38];
    b.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.35].CGColor;
    b.layer.borderWidth = 2;
    b.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [b setTitle:t forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:27];
    [b addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    return b;
}

- (void)movePan:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        self.move = CGPointZero;
    } else {
        self.move = CGPointMake(MAX(-1,MIN(1,p.x/38.0)), MAX(-1,MIN(1,-p.y/38.0)));
    }
}

- (void)tick:(CADisplayLink *)link {
    if (self.last == 0) self.last = link.timestamp;
    CGFloat dt = MIN(0.05, link.timestamp - self.last);
    self.last = link.timestamp;

    CGFloat speed = 7.5;
    self.player.position = SCNVector3Make(
        MAX(-40,MIN(40,self.player.position.x + self.move.x * speed * dt)),
        self.player.position.y,
        MAX(-40,MIN(40,self.player.position.z - self.move.y * speed * dt))
    );

    if (fabs(self.move.x)+fabs(self.move.y) > 0.05) {
        self.player.eulerAngles = SCNVector3Make(0, atan2(self.move.x, self.move.y), 0);
    }

    for (SCNNode *bot in self.bots) {
        if (!bot.parentNode) continue;
        CGFloat dx = self.player.position.x - bot.position.x;
        CGFloat dz = self.player.position.z - bot.position.z;
        CGFloat len = MAX(0.01, sqrt(dx*dx+dz*dz));
        bot.position = SCNVector3Make(bot.position.x + dx/len*1.8*dt, bot.position.y, bot.position.z + dz/len*1.8*dt);
        if (len < 1.2) [self damage:0.006];
    }

    for (SCNNode *loot in self.loots) {
        if (!loot.parentNode) continue;
        CGFloat dx = loot.position.x - self.player.position.x;
        CGFloat dz = loot.position.z - self.player.position.z;
        if (sqrt(dx*dx+dz*dz) < 1.5) {
            [loot removeFromParentNode];
            self.ammo += 10;
            self.hp = MIN(1.0,self.hp+0.12);
            self.hpBar.progress = self.hp;
        }
    }

    SCNVector3 cam = SCNVector3Make(self.player.position.x, self.player.position.y+5.2, self.player.position.z+8.5);
    self.camera.position = SCNVector3Make(
        self.camera.position.x + (cam.x-self.camera.position.x)*0.10,
        self.camera.position.y + (cam.y-self.camera.position.y)*0.10,
        self.camera.position.z + (cam.z-self.camera.position.z)*0.10
    );
    [self.camera lookAt:SCNVector3Make(self.player.position.x,self.player.position.y+0.8,self.player.position.z)];
}

- (void)fire {
    if (self.ammo <= 0) return;
    self.ammo--;
    self.ammoLabel.text = [NSString stringWithFormat:@"%ld/90\nAR",(long)self.ammo];

    SCNNode *flash = [CharacterFactory sphere:0.25 color:UIColor.yellowColor];
    flash.position = SCNVector3Make(self.player.position.x,self.player.position.y+1.0,self.player.position.z-0.8);
    [self.scene.rootNode addChildNode:flash];
    [flash runAction:[SCNAction sequence:@[[SCNAction fadeOutWithDuration:0.08],[SCNAction removeFromParentNode]]]];

    SCNNode *nearest = nil;
    CGFloat best = 999;
    for (SCNNode *bot in self.bots) {
        if (!bot.parentNode) continue;
        CGFloat dx = bot.position.x - self.player.position.x;
        CGFloat dz = bot.position.z - self.player.position.z;
        CGFloat d = sqrt(dx*dx+dz*dz);
        if (d < best && d < 15) { best = d; nearest = bot; }
    }
    if (nearest) {
        [nearest removeFromParentNode];
        self.kills++;
        self.alive = MAX(1,self.alive-1);
        self.killsLabel.text = [NSString stringWithFormat:@"ABATES %ld",(long)self.kills];
        self.aliveLabel.text = [NSString stringWithFormat:@"VIVOS %ld",(long)self.alive];
        if (self.kills >= 10 || self.alive <= 1) [self result:@"BOOYAH!" sub:@"Hora do show!"];
    }
}

- (void)jump {
    [self.player runAction:[SCNAction sequence:@[
        [SCNAction moveByX:0 y:1.0 z:0 duration:0.16],
        [SCNAction moveByX:0 y:-1.0 z:0 duration:0.20]
    ]]];
}
- (void)crouch {}
- (void)openInventory {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"EQUIPAMENTO"
        message:@"AR-18 30/90\nSMG-9 28/120\nKit Médico x3\nMunição AR x90\nGranada x2\nParede de Gel x4"
        preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"FECHAR" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}
- (void)damage:(CGFloat)v {
    self.hp = MAX(0,self.hp-v);
    self.hpBar.progress = self.hp;
    if (self.hp <= 0) [self result:@"FIM DE PARTIDA" sub:@"Tente novamente"];
}
- (void)result:(NSString *)title sub:(NSString *)sub {
    [self.link invalidate];
    UILabel *l = [[UILabel alloc] initWithFrame:self.view.bounds];
    l.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    l.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
    l.textColor = [title isEqualToString:@"BOOYAH!"] ? UIColor.yellowColor : UIColor.whiteColor;
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:52 weight:UIFontWeightBlack];
    l.numberOfLines = 2;
    l.text = [NSString stringWithFormat:@"%@\n%@",title,sub];
    [self.view addSubview:l];
}
- (CGFloat)rnd:(CGFloat)a b:(CGFloat)b {
    return a + ((CGFloat)arc4random_uniform(10000)/10000.0)*(b-a);
}
@end

@interface MenuVC : UIViewController
@end

@implementation MenuVC
- (void)viewDidLoad {
    [super viewDidLoad];

    CAGradientLayer *g = [CAGradientLayer layer];
    g.frame = self.view.bounds;
    g.colors = @[
        (id)[UIColor colorWithRed:0.05 green:0.08 blue:0.10 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.14 green:0.18 blue:0.23 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0.02 green:0.03 blue:0.04 alpha:1].CGColor
    ];
    [self.view.layer addSublayer:g];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20,150,self.view.bounds.size.width-40,80)];
    title.text = @"BATTLE ISLAND";
    title.textColor = UIColor.yellowColor;
    title.font = [UIFont systemFontOfSize:44 weight:UIFontWeightBlack];
    title.textAlignment = NSTextAlignmentCenter;
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:title];

    UILabel *year = [[UILabel alloc] initWithFrame:CGRectMake(20,225,self.view.bounds.size.width-40,44)];
    year.text = @"2018";
    year.textColor = UIColor.whiteColor;
    year.font = [UIFont systemFontOfSize:34 weight:UIFontWeightBlack];
    year.textAlignment = NSTextAlignmentCenter;
    year.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:year];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(20,278,self.view.bounds.size.width-40,30)];
    sub.text = @"Battle royale mobile offline 3D";
    sub.textColor = UIColor.whiteColor;
    sub.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    sub.textAlignment = NSTextAlignmentCenter;
    sub.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:sub];

    BIButton *start = [BIButton buttonWithTitle:@"COMEÇAR" color:UIColor.yellowColor];
    start.frame = CGRectMake(38,self.view.bounds.size.height-165,self.view.bounds.size.width-76,60);
    start.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];

    NSArray *names = @[@"LOJA",@"ARMAS",@"CONFIG"];
    for (NSInteger i=0;i<3;i++) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        b.frame = CGRectMake(38+i*((self.view.bounds.size.width-96)/3+10), self.view.bounds.size.height-88, (self.view.bounds.size.width-96)/3, 44);
        b.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        b.backgroundColor = [UIColor colorWithWhite:1 alpha:0.13];
        b.layer.cornerRadius = 9;
        [b setTitle:names[i] forState:UIControlStateNormal];
        [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBlack];
        [self.view addSubview:b];
    }
}
- (void)start {
    GameVC *g = [GameVC new];
    g.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:g animated:YES completion:nil];
}
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic,strong) UIWindow *window;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [MenuVC new];
    [self.window makeKeyAndVisible];
    return YES;
}
@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(AppDelegate.class));
    }
}
