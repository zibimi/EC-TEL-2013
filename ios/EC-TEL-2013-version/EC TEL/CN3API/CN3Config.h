//
//  CN3Config.h
//  CN3
//
//  Created by Gang on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define BASE_URL @"http://halley.exp.sis.pitt.edu/cn3mobile/"
#define USER_BOOKMARK BASE_URL@"schedule.jsp?userid=%@&eventid=%@"
#define BOOKMARK BASE_URL@"bookmarkPaper.jsp?userid=%@&contentid=%@"
#define UNBOOKMARK BASE_URL@"unbookmarkPaper.jsp?userid=%@&contentid=%@"
#define CONTENT_RECOM BASE_URL@"contentBasedSysRec.jsp?userID=%@&conferenceID=%@"
#define CHECK_EVENT_UPDATE BASE_URL@"checkLastUpdatedEventSessionTime.jsp?eventID=%@"
#define ALL_SESSIONS BASE_URL@"allSessionsAndPresentations.jsp?conferenceID=%@"
#define ALL_CONTENTS BASE_URL@"allContentsAndAuthors.jsp?conferenceID=%@"
#define UPDATE_CONFERENCE BASE_URL@"conferencelist.jsp"

#define RECOMEND_URL BASE_URL@"paperBookmarkAlike.jsp?contentID=%@&conferenceID=%@&maxno=%@"
#define SIGNUP_URL @"http://halley.exp.sis.pitt.edu/cn3/signup.php?conferenceID=%@"
#define LOGIN_URL @"http://halley.exp.sis.pitt.edu/cn3mobile/authenticateUser.jsp"
#define RECOMENDATION_URL @"http://halley.exp.sis.pitt.edu/cn3mobile/contentBasedSysRec.jsp?userID=%@&conferenceID=%@"

#define MY_FRIEND_URL @"http://halley.exp.sis.pitt.edu/cn3mobile/friendlist.jsp?userID=%@"

#define RATE_URL @"http://halley.exp.sis.pitt.edu/cn3mobile/logRecFeedback.jsp?userID=%@&contentID=%@&feedback=%@"



