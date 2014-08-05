//
//  totEventName.h
//  totdev
//
//  Created by Lixing Huang on 5/5/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#ifndef totdev_totEventName_h
#define totdev_totEventName_h

// for preferences not associated with a baby
const static int       PREFERENCE_NO_BABY     = 0;

// preference keys
static NSString *PREFERENCE_LOGGED_IN   = @"pref/logged_in"; // who is currently logged in
static NSString *PREFERENCE_LAST_LOGGED_IN = @"pref/last_logged_in"; // the last logged in user
static NSString *PREFERENCE_ACTIVE_BABY_ID = @"pref/active_baby_id";
static NSString *PREFERENCE_ACCOUNT = @"pref/account/%@"; // user name -> password
static NSString *PREFERENCE_ACCOUNT_QUERY = @"pref/account/"; // for query all accounts
static NSString *PREFERENCE_DEFAULT_BABY = @"pref/defaultbaby/%@"; // default baby for a user
static NSString *PREFERENCE_LAST_PHOTO_VIEWED = @"pref/last_photo_viewed/%@"; // the last viewed photo (activity) for a user
static NSString *PREFERENCE_BABY_AVATAR = @"pref/baby_avatar"; // the filename of the avatar image that is used in timeline summary card

// mapping from user to baby and from baby to user
static NSString *PREFERENCE_USER_BABY = @"pref/user_baby/%@"; // user id -> baby id
static NSString *PREFERENCE_BABY_USER = @"pref/baby_user/%@"; // baby id -> user id

// for tutorial, whether it has been shown
static NSString *EVENT_TUTORIAL_SHOW     = @"tutorial";

// baby information
static NSString *BABY_NAME              = @"pref/baby/name";
static NSString *BABY_BIRTHDAY          = @"pref/baby/birthday";
static NSString *BABY_SEX               = @"pref/baby/sex";

// basic
static NSString *EVENT_BASIC_HEIGHT     = @"basic/height";
static NSString *EVENT_BASIC_WEIGHT     = @"basic/weight";
static NSString *EVENT_BASIC_HEAD       = @"basic/head";
static NSString *EVENT_BASIC_SLEEP      = @"basic/sleep";
static NSString *EVENT_BASIC_LANGUAGE   = @"basic/language";
static NSString *EVENT_BASIC_DIAPER     = @"basic/diaper";
static NSString *EVENT_BASIC_FEEDING    = @"basic/feeding";

// feeding
//static NSString *EVENT_FEEDING_MILK     = @"feeding/milk";
//static NSString *EVENT_FEEDING_WATER    = @"feeding/water";
//static NSString *EVENT_FEEDING_RICE     = @"feeding/rice";
//static NSString *EVENT_FEEDING_FRUIT    = @"feeding/fruit";
//static NSString *EVENT_FEEDING_VEGETABLE= @"feeding/vegetable";
//static NSString *EVENT_FEEDING_CHEESE   = @"feeding/cheese";
//static NSString *EVENT_FEEDING_BREAD    = @"feeding/bread";
//static NSString *EVENT_FEEDING_EGG      = @"feeding/egg";

// activity - emotion
static NSString *EVENT_EMOTION_HAPPY    = @"emotion/emotion_happy";
static NSString *EVENT_EMOTION_SAD      = @"emotion/emotion_sad";
static NSString *EVENT_EMOTION_SURPRISE = @"emotion/emotion_surprise";
static NSString *EVENT_EMOTION_ANGRY    = @"emotion/emotion_angry";
static NSString *EVENT_EMOTION_DISGUST  = @"emotion/emotion_disgust";
static NSString *EVENT_EMOTION_FEAR     = @"emotion/emotion_fear";

static NSString *EVENT_MOTOR_STAND      = @"motor_skill/motor_skill_stand";
static NSString *EVENT_MOTOR_WALK       = @"motor_skill/motor_skill_walk";
static NSString *EVENT_MOTOR_RUN        = @"motor_skill/motor_skill_run";
static NSString *EVENT_MOTOR_DANCE      = @"motor_skill/motor_skill_dance";
static NSString *EVENT_MOTOR_JUMP       = @"motor_skill/motor_skill_jump";
static NSString *EVENT_MOTOR_CRUISE     = @"motor_skill/motor_skill_cruise";
static NSString *EVENT_MOTOR_CRAWL      = @"motor_skill/motor_skill_crawl";
static NSString *EVENT_MOTOR_SIT        = @"motor_skill/motor_skill_sit";
static NSString *EVENT_MOTOR_ROLLOVER   = @"motor_skill/motor_skill_roll_over";
static NSString *EVENT_MOTOR_KICKLEG    = @"motor_skill/motor_skill_kick_leg";
static NSString *EVENT_MOTOR_LIFTNECK   = @"motor_skill/motor_skill_lift_neck";

// activity for photo including labels
static NSString *ACTIVITY_PHOTO           = @"activity/photo/";
static NSString *ACTIVITY_PHOTO_REPLACABLE= @"activity/photo/%@";

// scrapbook
static NSString *SCRAPBOOK           = @"scrapbook/";
static NSString *SCRAPBOOK_REPLACABLE= @"scrapbook/%@/%@";

#endif
