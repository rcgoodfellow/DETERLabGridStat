module GSST.AST 
	(
	
	Name, Port, From, To, Edge, Rate, PubName, Redundancy, Latency,	
	Broker(..), NameServer(..), DataPlane(..), ForwardingEngine(..), Link(..), Publisher(..),
	Subscriber(..), PubVar(..), SubVar(..)
	
	) where
	
type Name = String
type Port = Int
type From = Name
type To = Name
type Edge = Name
type Rate = Int
type PubName = Name
type Redundancy = Int
type Latency = Int

data Broker = Broker Name NameServer DataPlane [Publisher] [Subscriber] deriving (Show)
data NameServer = NameServer Port Name deriving (Show)
data DataPlane = DataPlane [ForwardingEngine] [Link] deriving (Show)
data ForwardingEngine = ForwardingEngine Name deriving (Show)
data Link = Link From To deriving (Show)
data Publisher = Publisher Name Edge [PubVar] deriving (Show)
data Subscriber = Subscriber Name Edge [SubVar] deriving (Show)
data PubVar = PubVar Name Rate deriving (Show)
data SubVar = SubVar PubName Name Rate Redundancy Latency deriving (Show)
