$(document).ready(function(){
	
	var data = 
	{
		"event" : {
			"id": 1,
			"name": "Djent Fest",
			"date": "2012-03-22",
			"image_url": "http://dummyimage.com/200x200/54575c/ffffff.jpg",
			"songs_count": 53,
			"videos_count": 8,
			"comments_count": 26,
			"most_popular_video_id": null,
			"place": {
				"id": 2,
				"name": "Explicabo",
				"latitude": 36.1257785585,
				"longitude": -87.624262,
				"user_id": 43
			}
		},
		"playlist" : {
		"timelines" : [
			{
			"position" : 1,
			"clips_count" : 3,
			"clips" : [
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://www.808.dk/pics/video/gizmo.ogv?1"
				},
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://allwebco-templates.com/support/scripts/HTML5Video/yourvideo.ogv?1"
				},
				/*{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 34,
				"media" : "http://www.html5rocks.com/en/tutorials/video/basics/Chrome_ImF.ogv?1"
				},*/
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 39,
				"duraton" : 60,
				"media" : "http://clips.vorwaerts-gmbh.de/VfE.ogv?1"
				},
			]
			},
			{
			"position" : 2,
			"clips_count" : 3,
			"clips" : [
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://www.808.dk/pics/video/gizmo.ogv?2"
				},
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://allwebco-templates.com/support/scripts/HTML5Video/yourvideo.ogv?2"
				},
				/*{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 34,
				"media" : "http://www.html5rocks.com/en/tutorials/video/basics/Chrome_ImF.ogv?1"
				},*/
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 39,
				"duration" : 60,
				"media" : "http://clips.vorwaerts-gmbh.de/VfE.ogv?2"
				},
			]
			},
			{
			"position" : 3,
			"clips_count" : 3,
			"clips" : [
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://www.808.dk/pics/video/gizmo.ogv?3"
				},
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://allwebco-templates.com/support/scripts/HTML5Video/yourvideo.ogv?3"
				},
				/*{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 34,
				"media" : "http://www.html5rocks.com/en/tutorials/video/basics/Chrome_ImF.ogv?1"
				},*/
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 39,
				"duration" : 60,
				"media" : "http://clips.vorwaerts-gmbh.de/VfE.ogv?3"
				},
			]
			},
			{
			"position" : 4,
			"clips_count" : 3,
			"clips" : [
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://www.808.dk/pics/video/gizmo.ogv?4"
				},
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 5,
				"media" : "http://allwebco-templates.com/support/scripts/HTML5Video/yourvideo.ogv?4"
				},
				/*{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 0,
				"duration" : 34,
				"media" : "http://www.html5rocks.com/en/tutorials/video/basics/Chrome_ImF.ogv?1"
				},*/
				{
				"id" : "here will be id of clip in system",
				"rating" : "here will be rating of clip",
				"position" : 1,
				"start_time" : 39,
				"duration" : 60,
				"media" : "http://clips.vorwaerts-gmbh.de/VfE.ogv?4"
				},
			]
			}
		]
		}
	};
	
	var sections =  $(".video-section");
	var mastertrack = {
		element: $("#mastertrack")[0],
		playpause: $("#player-playpause")[0],
		hasHours: false,
		proxyTime: [],
		duration: $("#player-controls").find(".duration"),
		currentTime: $("#player-controls").find(".currenttime"),
		total: $("#player-controls").find(".total"),
		progress: $("#player-controls").find(".current")[0],
		toggleMastertrack: function(){
			if(this.element.paused) {
				this.element.play();
			} else {
				this.element.pause();
			}
		},
		play: function() {
			$(this.playpause).text("Pause");
			$(this.playpause).toggleClass("paused");

			this.hasHours = (this.element.duration / 3600) >= 1.0;
			$(this.duration).text(formatTime(this.element.duration, this.hasHours));
			$(this.currentTime).text(formatTime(0), this.hasHours);
			if(this.element.paused) {
				this.element.play();
			}
		},
		pause: function(){
			$(this.playpause).text("Play");
			$(this.playpause).toggleClass("paused");
			if(!this.element.paused) {
				this.element.pause();
			}
		},
		timeupdate: function(){
			$(this.currentTime).text(formatTime(this.element.currentTime, this.hasHours));
			var progress = Math.floor(this.element.currentTime) / Math.floor(this.element.duration);
			this.progress.style.width = Math.floor(progress * this.total.width()) + "px";
		}
	}
	
	var jsplayer = {
		paused: true,
		play: function(){
			this.paused = false;
			$.each(sections, function(sectIndex, sect) {
				sect.controls.currentVideoContainer.play();
				/*var videos = $(sect).find(".video-item");
				$.each(videos, function(vidIndex, vid) {
					if(vidIndex == sect.controls.playedVideoIndex) {
						vid.play();
						sect.controls.video.play();
					}
				});*/
			});
			mastertrack.play();
		},
		pause: function(){
			this.paused = true;
			$.each(sections, function(sectIndex, sect) {
				sect.controls.currentVideoContainer.pause();
				/*var videos = $(sect).find(".video-item");
				$.each(videos, function(vidIndex, vid) {
					if(vidIndex == sect.controls.playedVideoIndex) {
						vid.pause();
						sect.controls.video.pause();
					}
				});*/
			});
			mastertrack.pause();
		},
		/*togglePlayback: function(){
			$.each(sections, function(sectIndex, sect) {
				var videos = $(sect).find(".video-item");
				$.each(videos, function(vidIndex, vid) {
					if(vidIndex == sect.controls.playedVideoIndex) 
					{
						sect.controls.video.togglePlayback();
					}
				});
			});
		},*/
		init: function() {
			mastertrack.element.src = "mastertrack.ogg";
			mastertrack.element.volume = 0;
			mastertrack.element.addEventListener("play", $.proxy(mastertrack.play, mastertrack));
			mastertrack.element.addEventListener("pause", $.proxy(mastertrack.pause, mastertrack));
			mastertrack.element.addEventListener("timeupdate", $.proxy(mastertrack.timeupdate, mastertrack));
			
			$.each(sections, function(sectionIndex, section) {
				mastertrack.proxyTime[sectionIndex] = 0;
				var videos = $(section).find(".video-item");
				section.controls = {
					playedVideoIndex: 0,
					playpause: $(section).find(".playpause"),
					total: $(section).find(".total"),
					buffered: $(section).find(".buffered"),
					progress: $(section).find(".current"),
					duration: $(section).find(".duration"),
					currentTime: $(section).find(".currenttime"),
					hasHours: false,
					loadNextVideo: false,
					canplay: true,
					waitingVidNumber: false,
					currentVideoContainer: $(section).find('video').not(".hide")[0],
					nextVideoContainer: $(section).find('.hide')[0],
					video: {
						togglePlayback: function(){
							(videos[section.controls.playedVideoIndex].paused) ? videos[section.controls.playedVideoIndex].play() : videos[section.controls.playedVideoIndex].pause();
						},
						ended: function(){
							this.pause();
							section.controls.playpause.text("Play");
							section.controls.playpause.toggleClass("paused");
							
							if(data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex+1])
							{
								$(section.controls.currentVideoContainer).toggleClass("hide");
								$(section.controls.nextVideoContainer).toggleClass("hide");
								//section.controls.currentVideoContainer = section.controls.nextVideoContainer;
								var buf = section.controls.currentVideoContainer;
								section.controls.currentVideoContainer = section.controls.nextVideoContainer;
								section.controls.nextVideoContainer = buf;
								if(data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex+2])
								{
									section.controls.nextVideoContainer.src = data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex+2].media;
								}
								section.controls.playedVideoIndex++;
								section.controls.currentVideoContainer.play();
							}
						},
						play: function(){
							if(this.currentTime < 1 && section.controls.playedVideoIndex != 0)
							{
								var errTime = mastertrack.element.currentTime 
									- mastertrack.proxyTime[sectionIndex] 
									- parseInt(data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex-1].duration);
								if(this.currentTime) this.currentTime = errTime;
								mastertrack.proxyTime[sectionIndex] = mastertrack.element.currentTime;
								//console.log(errTime);
								//console.log(this, this.currentTime, this.duration);
							}
							section.controls.playpause.text("Pause");
							section.controls.playpause.toggleClass("paused");
							if (this && this.buffered && this.buffered.length > 0 && this.buffered.end && this.duration)
							{
								section.controls.hasHours = (this.duration / 3600) >= 1.0;
								section.controls.duration.text(formatTime(this.duration, section.controls.hasHours));
								section.controls.currentTime.text(formatTime(0),section.controls.hasHours);
							} //else console.log('can\'t play');/*****/
						},
						pause: function(){
							section.controls.playpause.text("Play");
							section.controls.playpause.toggleClass("paused");
						},
						click: function(){
							//section.controls.video.togglePlayback();
						},
						timeupdate: function(){
							section.controls.currentTime.text(formatTime(this.currentTime, section.controls.hasHours));
							var progress = Math.floor(this.currentTime) / Math.floor(this.duration);
							section.controls.progress[0].style.width = Math.floor(progress * section.controls.total.width()) + "px";
						},
						waiting: function(){//console.log('w', this);
							section.controls.waitingVidNumber = true;
							section.controls.canplay = false;
							jsplayer.pause();
						},
						loadedmetadata : function(){//console.log('l');
							if(!section.controls.canplay)
							{
								var play = true;
								section.controls.waitingVidNumber = false;
								$.each(sections, function(sectIndex, sect) {
									console.log(sect.controls.waitingVidNumber);
									if (this && this.buffered && this.buffered.length > 0 && this.buffered.end && this.duration)
										console.log(this.currentTime, this.duration);
									if(sect.controls.waitingVidNumber == true) play = false;
								});
								if(play)
								{
									$.each(sections, function(sectIndex, sect) {
										var videos = $(sect).find(".video-item");
										$.each(videos, function(vidIndex, vid) {
											if(vidIndex == sect.controls.playedVideoIndex) {
												if(vid.currentTime == vid.duration) {
													if(videos[sect.controls.playedVideoIndex+1]) {
														videos[sect.controls.playedVideoIndex].pause();
														videos[sect.controls.playedVideoIndex+1].play();
														videos[sect.controls.playedVideoIndex+1].pause();
														sect.controls.playedVideoIndex++;
													}
												}
											}
										});
									});
									jsplayer.play();
									section.controls.canplay = true;
								}
							}
						},
						progress: function(){
							var buffered;
							if (this && this.buffered && this.buffered.length > 0 && this.buffered.end && this.duration) {
								buffered = (this.buffered.end(0) / this.duration);
							} 
							else if (this && this.bytesTotal != undefined && this.bytesTotal > 0 && this.bufferedBytes != undefined) {
								buffered = this.bufferedBytes / this.bytesTotal;
							}
							
							if(buffered > 0.9 && !this.loadNextVideo)
							{
								this.loadNextVideo = true;
								if(data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex+1].media) {
									if(section.controls.playedVideoIndex > 0 && !$(this).hasClass('hide')){
										/*var buf = section.controls.currentVideoContainer;
										section.controls.currentVideoContainer = section.controls.nextVideoContainer;
										section.controls.nextVideoContainer = buf;*/
									}
									if(!$(this).hasClass('hide'))
										section.controls.nextVideoContainer.src = data.playlist.timelines[sectionIndex].clips[section.controls.playedVideoIndex+1].media;
									/*if(index == 0)*/ section.controls.nextVideoContainer.setAttribute('preload', 'auto');
								}
							}
							else
							{
								section.controls.buffered[0].style.width =  Math.floor(buffered * section.controls.total.width()) + "px";
							}
						}
					}
				};
				
				$.each(videos, function(index, video) {
					if(index == 0) {
						if(data.playlist.timelines[sectionIndex].clips[0].media) {
							section.controls.currentVideoContainer.src = data.playlist.timelines[sectionIndex].clips[0].media;}
					}
					
					this.muted = true;
					video.addEventListener("ended", $.proxy(section.controls.video.ended, this));
					video.addEventListener("play", $.proxy(section.controls.video.play, this));
					video.addEventListener("pause", $.proxy(section.controls.video.pause, this));
					video.addEventListener("click", $.proxy(section.controls.video.click, this));
					video.addEventListener("timeupdate", $.proxy(section.controls.video.timeupdate, this));
					video.addEventListener("waiting", $.proxy(section.controls.video.waiting, this));
					video.addEventListener("progress", $.proxy(section.controls.video.progress, this));
					video.addEventListener("loadedmetadata", $.proxy(section.controls.video.loadedmetadata, this));
					
					section.controls.total.click(function(e) {
						var x = (e.pageX - this.offsetLeft)/$(this).width();
						this.currentTime = x * this.duration;
					});
				});
		
				section.controls.playpause[0].addEventListener("click", function(){
					section.controls.video.togglePlayback();
				});
				
				$("#player-controls")[0].addEventListener("click", function(){
					section.controls.video.togglePlayback();
				});
			});
				
			$("#player-controls")[0].addEventListener("click", $.proxy(function (){
				mastertrack.toggleMastertrack();
			}, this));
		}
	}
	
	jsplayer.init();

	function formatTime(time, hours) {
		if (hours) {
			var h = Math.floor(time / 3600);
			time = time - h * 3600;

			var m = Math.floor(time / 60);
			var s = Math.floor(time % 60);

			return h.lead0(2)  + ":" + m.lead0(2) + ":" + s.lead0(2);
		} else {
			var m = Math.floor(time / 60);
			var s = Math.floor(time % 60);
			
			return m.lead0(2) + ":" + s.lead0(2);
		}
	}

	Number.prototype.lead0 = function(n) {
		var nz = "" + this;
		while (nz.length < n) {
			nz = "0" + nz;
		}
		return nz;
	};

});
