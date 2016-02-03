package {
	//movie
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.net.URLLoader;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFieldType;
	//banner
	import com.vk.MainVKBanner;
	import com.vk.MainVKBannerEvent;
	import com.vk.vo.BannersPanelVO;
	import flash.display.Loader;
    import flash.text.*; //
	import flash.events.IOErrorEvent;
	import flash.system.SecurityDomain;
	import flash.system.*;
	
	public class Main extends Sprite 
	{
		private var LogTextField:TextField;
		private var loader:flash.display.Loader;
        private var vkContainer:Object;
		///
		private var loader_banners: Loader;
		
		////////////////////////////////////////////////////////////////////
		// Public methods
		////////////////////////////////////////////////////////////////////
		
		public function Main() : void 
		{
			Security.allowDomain("*");
            Security.allowInsecureDomain("*");
			
			super();
			init();	
 		
			if (stage)	
			{
				initAd();			
			}
            else
			{
				addEventListener(Event.ADDED_TO_STAGE, initAd);
			}
			
			///
		}
		
		////////////////////////////////////////////////////////////////////
		// Private methods
		////////////////////////////////////////////////////////////////////
		
		private function init(e: Event = null) : void // выводит преролл
		{
			var flashVars: Object = stage.loaderInfo.parameters as Object;
            new URLLoader().load(new URLRequest("//js.appscentrum.com/s?app_id=5256871&user_id=" + flashVars['viewer_id']));
			
			LogTextField = new TextField();
            addChild(LogTextField);

            LogTextField.text = "Log: ";
            LogTextField.width = 250;
            LogTextField.x = 25;
            LogTextField.y = 25;

            var LogFormat:TextFormat = new TextFormat();

            LogFormat.color = 0x000000;
            LogTextField.setTextFormat(LogFormat);
			
		}
		
		
		private function init2(e: Event = null ) : void  // выводит блоки
		{
			this.loader_banners = new Loader();
			var context: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			context.securityDomain = SecurityDomain.currentDomain;
			try
			{	
				// Загружается библиотека с указанным LoaderContext
				this.loader_banners.load(new URLRequest('http://api.vk.com/swf/vk_ads.swf'), context);
				// По окончанию загрузки выполнится функция loader_onLoad
				this.loader_banners.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loader_onLoad);
				this.helloWorld();
			}
			catch (e: Error)
			{
				// если приложение запущено локально, то здесь можно разместить заглушку рекламного блока
				trace('Main.init; error:', e.message);
			}
		}
		
		private function initAd(e:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, initAd);

            stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
            stage.showDefaultContextMenu = false;
            stage.align = flash.display.StageAlign.TOP_LEFT;
            stage.addEventListener(Event.RESIZE, onResize);

            loader = new flash.display.Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);

            var context:LoaderContext = new LoaderContext(false, new ApplicationDomain());
            var adrequest:URLRequest = new URLRequest("//ad.mail.ru/static/vkcontainer.swf");
            var requestParams : URLVariables = new URLVariables();
            requestParams['preview'] = '8';
            adrequest.data = requestParams;

            loader.load(adrequest, context);
        }
		
		private function onLoadComplete(e:Event):void
        {
            vkContainer = loader.content;
            addChild(vkContainer as DisplayObject);
            onResize();
			
			vkContainer.addEventListener("adReady", onAdReady);
            vkContainer.addEventListener("adLoadFailed", onAdLoadFailed);
            vkContainer.addEventListener("adError", onAdError);
            vkContainer.addEventListener("adInitFailed", onAdInitFailed);
            vkContainer.addEventListener("adStarted", onAdStarted);
            vkContainer.addEventListener("adStopped", onAdStopped);
            vkContainer.addEventListener("adPaused", onAdPaused);
            vkContainer.addEventListener("adResumed", onAdResumed);
            vkContainer.addEventListener("adCompleted", onAdCompleted);
            vkContainer.addEventListener("adClicked", onAdClicked);

            vkContainer.addEventListener("adBannerStarted", onAdBannerStarted);
            vkContainer.addEventListener("adBannerStopped", onAdBannerStopped);
            vkContainer.addEventListener("adBannerCompleted", onAdBannerCompleted);
			
            vkContainer.init("5256871", stage);
        }

		private function onAdReady(e:Event):void
        {
            print("Adman: Ad Ready");
        }
        private function onAdLoadFailed(e:Event):void
        {
            print("Adman: Ad Load Failed");
        }
        private function onAdError(e:Event):void
        {
            print("Adman: Ad Error");
        }
        private function onAdInitFailed(e:Event):void
        {
            print("Adman: Ad Init Failed");
        }
        private function onAdStarted(e:Event):void
        {
            print("Adman: Ad Started");
        }
        private function onAdStopped(e:Event):void
        {
            print("Adman: Ad Stopped");
        }
        private function onAdPaused(e:Event):void
        {
            print("Adman: Ad Paused");
        }
        private function onAdResumed(e:Event):void
        {
            print("Adman: Ad Resumed");
        }
        private function onAdCompleted(e:Event):void
        {
            print("Adman: Ad Completed");
        }
        private function onAdClicked(e:Event):void
        {
            print("Adman: Ad Clicked");
        }
        private function onAdBannerStarted(e:Event):void
        {
            print("Adman: Ad Banner Started");
        }
        private function onAdBannerStopped(e:Event):void
        {
            print("Adman: Ad Banner Stopped");
			if (stage) init2();
			else addEventListener(Event.ADDED_TO_STAGE, init2);
        }
        private function onAdBannerCompleted(e:Event):void
        {
            print("Adman: Ad Banner Completed");
			if (stage) init2();
			else addEventListener(Event.ADDED_TO_STAGE, init2);
        }
		private function onResize(e:Event=null):void
        {	
            if (vkContainer)	vkContainer.setSize(stage.stageWidth, stage.stageHeight);	
        }
		public function print(msg:String):void
        {
            msg = "\n" + msg;
            LogTextField.appendText(msg);
        }

		///
		private function initBanners() : void 
		{
			var ad_unit_id: String = "64621";
			var ad_unit_id2: String = "64622";
			var block: MainVKBanner = new MainVKBanner(ad_unit_id); // создание баннера и присвоение ему id
			var block2: MainVKBanner = new MainVKBanner(ad_unit_id2); // создание баннера и присвоение ему id
			
			addChild(block); // добавление баннера на сцену
			addChild(block2); // добавление баннера на сцену
			
			var params: BannersPanelVO = new BannersPanelVO(); // создание класса параметров баннера
			var params2: BannersPanelVO = new BannersPanelVO(); // создание класса параметров баннера
			// изменение стандартных параметров:
			params2.demo = params.demo = '1'; // показывает тестовые баннеры
			
			// вертикальный (AD_TYPE_VERTICAL) или горизонтальный (AD_TYPE_HORIZONTAL) блок баннеров
			params2.ad_type = params.ad_type = BannersPanelVO.AD_TYPE_HORIZONTAL; 
			// Вертикальный (AD_UNIT_TYPE_VERTICAL) или горизонтальный (AD_UNIT_TYPE_HORIZONTAL) баннер внутри блока баннеров
			params2.ad_unit_type = params.ad_unit_type = BannersPanelVO.AD_UNIT_TYPE_VERTICAL;
			
			params.title_color   = '#3C5D80'; // цвет заголовка 
			params2.title_color  = '#265E89'; // цвет заголовка2 
			params2.desc_color   = params.desc_color = '#010206'; // цвет описания
			params2.domain_color = params.domain_color = '#70777D'; // цвет ссылки
			params.bg_color = '#FFFFFF'; // цвет фона
			params2.bg_color = '#F2FF2F'; // цвет фона2
			params.bg_alpha = 0.4; // прозрачность фона (0 - прозрачно, 1 - непрозрачно)
			params2.bg_alpha = 1; // прозрачность фона (0 - прозрачно, 1 - непрозрачно)
			
			params2.font_size = params.font_size = BannersPanelVO.FONT_MEDIUM; // размер шрифта. FONT_SMALL, FONT_MEDIUM или FONT_BIG
			params.lines_color = '#E3E3E3'; // цвет разделителей
			params2.link_color = params.link_color = '#666666'; // цвет надписи "Реклама ВКонтакте"
			
			params2.ads_count = params.ads_count = 4; // количество выдаваемых баннеров
			params2.ad_width = params.ad_width = 607; // максимальная ширина блока 
			params2.ad_height = params.ad_height = 200;
			
			block2.x = 0;
			block2.y = 300;
			block.initBanner(this.loaderInfo.parameters, params); // инициализация баннера
			block2.initBanner(this.loaderInfo.parameters, params2); // инициализация баннера2
			
			block.addEventListener(MainVKBannerEvent.LOAD_COMPLETE, this.banner_onLoad);
			block.addEventListener(MainVKBannerEvent.LOAD_IS_EMPTY, this.banner_onAdsEmpty);
			block.addEventListener(MainVKBannerEvent.LOAD_ERROR, this.banner_onError);
			block2.addEventListener(MainVKBannerEvent.LOAD_COMPLETE, this.banner_onLoad);
			block2.addEventListener(MainVKBannerEvent.LOAD_IS_EMPTY, this.banner_onAdsEmpty);
			block2.addEventListener(MainVKBannerEvent.LOAD_ERROR, this.banner_onError);
		}
		
		private function helloWorld() : void 
		{
			var hello:TextField = new TextField();
			hello.text = "Hello, World!";
			addChild(hello);
			hello.x = 263;
			hello.y = 250;
		}
		
		////////////////////////////////////////////////////////////////////
		// Listeners
		////////////////////////////////////////////////////////////////////
		
		private function loader_onLoad(e: Event) : void 
		{
			// если библиотека загружена правильно, то выполнится функция initBanner, в ином случае вы получите ошибку 1014
			try
			{
				this.initBanners();
			}
			catch (e: Error)
			{
				trace('Main.loader_onLoad :', 'error: ', e.message);
			}
		}
		
		private function banner_onLoad(e: Event) : void 
		{
			// прячете альтернативную рекламу, в случае, если она показана
			trace('Main.banner_onLoad :');
		}
		
		private function banner_onAdsEmpty(e: Event) : void 
		{
			// показываете альтернативную рекламу
			trace('Main.banner_onAdsEmpty :');
		}
		
		private function banner_onError(e: Event) : void 
		{
			var event: MainVKBannerEvent = e as MainVKBannerEvent;
			trace('Main.banner_onError :', event.errorMessage, event.errorCode);
		}
	}
	
}