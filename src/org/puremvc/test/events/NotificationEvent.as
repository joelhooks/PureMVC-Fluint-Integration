package org.puremvc.test.events
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	
	/**
	 * Event used for asyncronous testing of pureMVC proxies. This event is used to listen
	 * for notification dispatched by a proxy.
	 * 
	 * @see http://www.actionsnip.com/snippets/jspooner/multicore-proxy-unit-test
	 * @see http://github.com/roblocop/trdotcom/tree/master/tests/puremvc
	 * @author Joel
	 * 
	 */
	public class NotificationEvent extends Event
	{
		protected var _notification:INotification;
		
		public function NotificationEvent(notification:INotification)
		{
			super(notification.getName(), false, false);
			this._notification = notification;
		}
		
		public function get notification():INotification
		{
			return this._notification;
		}
		
	}
}