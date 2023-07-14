package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Contacts.*;
	
	public class SetAngle extends Sprite
	{
		private var worldObject:b2World;
		private var worldScale:Number = 30;
		
		private var playerObject:b2Body;
		private var playerLeft:Boolean = false;
		private var playerRight:Boolean = false;
		private var playerUp:Boolean = false;
		private var playerDown:Boolean = false;
		private var playerForce:b2Vec2 = new b2Vec2(0, 0);
		
		private var ballObject:b2Body;
		private var brickColors:Array = new Array("Purple", "Blue", "Green", "Yellow", "Orange", "Red");
		
		public function SetAngle()
		{
			worldObject = new b2World(new b2Vec2(0, 9.8), true);
			
			debugDraw();
			
			createBall();
			createPlayer(320, 420);
			
			for (var i:int = 1; i <= 15; i++)
			{
				for (var j:int = 1; j <= 6; j++)
				{
					createBrick(i * 40, j * 40, 15, 15, brickColors[j - 1]);
				}
			}
			
			createWall(320, 480, 320, 8, "Horizontal");
			createWall(320, 0, 320, 8, "Horizontal");
			createWall(0, 240, 8, 320, "Vertical");
			createWall(640, 240, 8, 320, "Vertical");
			
			addEventListener(Event.ENTER_FRAME, updateWorld);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pushButton);
			stage.addEventListener(KeyboardEvent.KEY_UP, releaseButton);
		}
		
		private function createBall()
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(280/worldScale, 300/worldScale);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			bodyDef.userData = new Object();
			bodyDef.userData.name = "ballObject";
			bodyDef.userData.asset = new ImgBall();
			addChild(bodyDef.userData.asset);
			
			var circleShape:b2CircleShape;
			circleShape = new b2CircleShape(25/worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 0.5;
			fixtureDef.restitution = 1;
			fixtureDef.friction = 0.1;
			fixtureDef.shape = circleShape;
			
			ballObject = worldObject.CreateBody(bodyDef);
			ballObject.CreateFixture(fixtureDef);
		}
		
		private function createPlayer(pX:Number, pY:Number):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX/worldScale, pY/worldScale);
			bodyDef.type = b2Body.b2_kinematicBody;
			
			bodyDef.userData = new Object();
			bodyDef.userData.name = "playerObject";
			bodyDef.userData.asset = new ImgPlayer();
			addChild(bodyDef.userData.asset);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(60/worldScale, 4/worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 1;
			fixtureDef.friction = 1;			
			
			playerObject = worldObject.CreateBody(bodyDef);
			playerObject.CreateFixture(fixtureDef);
			playerObject.SetSleepingAllowed(false);
		}
		
		private function pushButton(evt:KeyboardEvent)
		{
			if (evt.keyCode == 37)
			{
				playerForce = new b2Vec2(-10, 0);
			}
			if (evt.keyCode == 39)
			{
				playerForce = new b2Vec2(10, 0);
			}
			if (evt.keyCode == 38)
			{
				playerObject.SetAngle(-Math.PI/4);
			}
			if (evt.keyCode == 40)
			{
				playerObject.SetAngle(Math.PI/4);
			}
		}
				
		private function releaseButton(evt:KeyboardEvent)
		{
			if (evt.keyCode == 37 || evt.keyCode == 39)
			{
				playerForce = new b2Vec2(0, 0);
			}
			if (evt.keyCode == 38 || evt.keyCode == 40)
			{
				playerObject.SetAngle(0);
			}
		}
		
		private function createWall(pX:Number, pY:Number, W:Number, H:Number, type:String):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX/worldScale, pY/worldScale);
			bodyDef.type=b2Body.b2_staticBody;
			
			bodyDef.userData = new Object();
			bodyDef.userData.name = "wallObject";
			
			switch(type)
			{
				case "Horizontal":
					bodyDef.userData.asset = new ImgHorizontal();
					break;
				case "Vertical":
					bodyDef.userData.asset = new ImgVertical();
					break;
			}
			
			addChild(bodyDef.userData.asset);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(W/worldScale, H/worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.2;
			fixtureDef.friction = 1;
			
			var wallObject:b2Body = worldObject.CreateBody(bodyDef);
			wallObject.CreateFixture(fixtureDef);
		}

		
		private function createBrick(pX:Number, pY:Number, W:Number, H:Number, type:String):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX/worldScale, pY/worldScale);
			bodyDef.type = b2Body.b2_staticBody;
			
			bodyDef.userData = new Object();
			bodyDef.userData.name = "brickObject";
			
			switch(type)
			{
				case "Purple":
					bodyDef.userData.asset = new ImgPurple();
					break;
				case "Blue":
					bodyDef.userData.asset = new ImgBlue();
					break;
				case "Green":
					bodyDef.userData.asset = new ImgGreen();
					break;
				case "Yellow":
					bodyDef.userData.asset = new ImgYellow();
					break;
				case "Orange":
					bodyDef.userData.asset = new ImgOrange();
					break;
				case "Red":
					bodyDef.userData.asset = new ImgRed();
					break;
			}
			
			addChild(bodyDef.userData.asset);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(W/worldScale, H/worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.2;
			fixtureDef.friction = 1;
			
			var brickObject:b2Body = worldObject.CreateBody(bodyDef);
			brickObject.CreateFixture(fixtureDef);
		}

		private function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit);
			debugDraw.SetFillAlpha(0.5);
			
			worldObject.SetDebugDraw(debugDraw);
		}
		
		private function updateWorld(e:Event):void
		{
			worldObject.Step(1/30, 10, 10);
			worldObject.ClearForces();
			worldObject.DrawDebugData();
			
			playerObject.SetLinearVelocity(playerForce);
			
			for (var bodyList:b2Body = worldObject.GetBodyList(); bodyList; bodyList = bodyList.GetNext())
			{
				if (bodyList.GetUserData())
				{
					bodyList.GetUserData().asset.x = bodyList.GetPosition().x * worldScale;
					bodyList.GetUserData().asset.y = bodyList.GetPosition().y * worldScale;
					bodyList.GetUserData().asset.rotation = bodyList.GetAngle()*180/Math.PI;
					
					if (bodyList.GetUserData().name == "ballObject")
					{
						for (var contactList:b2ContactEdge = bodyList.GetContactList(); contactList; contactList = contactList.next)
						{						
							if (contactList.contact.GetFixtureA().GetBody().GetUserData().name == "brickObject")
							{
								removeChild(contactList.contact.GetFixtureA().GetBody().GetUserData().asset);
								worldObject.DestroyBody(contactList.contact.GetFixtureA().GetBody());
							}
						}
					}
				}
			}
		}
	}
}