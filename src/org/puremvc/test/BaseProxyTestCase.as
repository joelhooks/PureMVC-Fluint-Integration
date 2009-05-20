package org.puremvc.test
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import net.digitalprimates.fluint.tests.TestCase;
	
	import org.puremvc.as3.multicore.core.View;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.observer.Observer;
	import org.puremvc.test.events.NotificationEvent;
	
	/**
	 * BaseProxyTestCase is used to abstract the logic necessary to test multicore PureMVC proxies
	 * 
	 * @see http://www.actionsnip.com/snippets/jspooner/multicore-proxy-unit-test
	 * @see http://github.com/roblocop/trdotcom/tree/master/tests/puremvc
	 */
	public class BaseProxyTestCase extends TestCase
	{
		protected var appName:String = "testapp";
		protected var dispatcher:EventDispatcher;
		protected var observerMap:Dictionary;
		
		public function BaseProxyTestCase(appName:String="testApp")
		{
			this.appName = appName;
			super();
		}
		
		override protected function setUp():void
		{
			super.setUp();
			this.dispatcher = new EventDispatcher()
			this.observerMap = new Dictionary(true);
		}
		
		override protected function tearDown():void
		{
			super.tearDown();
			this.removeAllObservers();
			this.dispatcher = null;
			this.observerMap = null;
		}
		
		protected function registerObserver(notificationName:String, callback:Function, timeout:int=5000, timeoutCallback:Function=null):void
		{
			var asyncCallback:Function = this.asyncHandler( callback, timeout, notificationName, timeoutCallback )
			this.dispatcher.addEventListener( notificationName, asyncCallback, false, 0, true )
			var handler:Function = function(notification:INotification):void 
			{
				this.dispatcher.dispatchEvent(new NotificationEvent( notification ));	
			}
			View.getInstance( appName ).registerObserver( notificationName, new Observer( handler,this ) );
			this.observerMap[notificationName] = asyncCallback;
		}
		
		protected function removeObserver(notificationName:String):void
		{
			this.dispatcher.removeEventListener( notificationName, observerMap[notificationName] as Function );
			delete this.observerMap[notificationName];
			View.getInstance( this.appName ).removeObserver( notificationName,this );
		}
		
		protected function removeAllObservers():void
		{
			for( var notificationName:String in this.observerMap )
			{
				this.removeObserver(notificationName);
			}
		}
	}
}