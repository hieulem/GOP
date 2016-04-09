function video=Submeandivbyvar(video)

video= ( video-mean(video(:)) ) / var(video(:));