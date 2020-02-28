--- **Ops** - Commander Air Wing.
--
-- **Main Features:**
--
--    * Stuff
--
-- ===
--
-- ### Author: **funkyfranky**
-- @module Ops.WingCommander
-- @image OPS_WingCommander.png


--- WINGCOMMANDER class.
-- @type WINGCOMMANDER
-- @field #string ClassName Name of the class.
-- @field #boolean Debug Debug mode. Messages to all about status.
-- @field #string lid Class id string for output to DCS log file.
-- @field #table airwings Table of airwings.
-- @extends Core.Fsm#FSM

--- Be surprised!
--
-- ===
--
-- ![Banner Image](..\Presentations\CarrierAirWing\WINGCOMMANDER_Main.jpg)
--
-- # The WINGCOMMANDER Concept
--
--
--
-- @field #WINGCOMMANDER
WINGCOMMANDER = {
  ClassName      = "WINGCOMMANDER",
  Debug          =   nil,
  lid            =   nil,
  airwings       =    {},
}

--- Mission capability.
-- @type WINGCOMMANDER.Capability
-- @field #string missiontype Mission Type.
-- @field #number Ntot Total number of assets for this task.
-- @field #number Navail Number of available assets
-- @field #number Nonmission Number of assets currently on mission.

--- Mission resources.
-- @type WINGCOMMANDER.Recourses
-- @field #string missiontype Mission Type.
-- @field #number Ntot Total number of assets for this task.
-- @field #number Navail Number of available assets
-- @field #number Nonmission Number of assets currently on mission.


--- WINGCOMMANDER class version.
-- @field #string version
WINGCOMMANDER.version="0.0.1"

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TODO list
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: Add tasks.
-- TODO: 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Constructor
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Create a new WINGCOMMANDER object and start the FSM.
-- @param #WINGCOMMANDER self
-- @param Core.Set#SET_UNITS AgentSet Set of agents (units) providing intel. 
-- @return #WINGCOMMANDER self
function WINGCOMMANDER:New(AgentSet)

  -- Inherit everything from INTEL class.
  local self=BASE:Inherit(self, INTEL:New(AgentSet)) --#WINGCOMMANDER

  -- Set some string id for output to DCS.log file.
  self.lid=string.format("WINGCOMMANDER | ")

  -- Start State.
  self:SetStartState("Stopped")
  
  -- Add FSM transitions.
  --                 From State  -->   Event        -->     To State
  self:AddTransition("Stopped",       "Start",              "Running")     -- Start FSM.

  self:AddTransition("*",             "Sitrep",             "*")          -- WINGCOMMANDER status update


  ------------------------
  --- Pseudo Functions ---
  ------------------------

  --- Triggers the FSM event "Start". Starts the WINGCOMMANDER. Initializes parameters and starts event handlers.
  -- @function [parent=#WINGCOMMANDER] Start
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "Start" after a delay. Starts the WINGCOMMANDER. Initializes parameters and starts event handlers.
  -- @function [parent=#WINGCOMMANDER] __Start
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.

  --- Triggers the FSM event "Stop". Stops the WINGCOMMANDER and all its event handlers.
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "Stop" after a delay. Stops the WINGCOMMANDER and all its event handlers.
  -- @function [parent=#WINGCOMMANDER] __Stop
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.

  --- Triggers the FSM event "FlightStatus".
  -- @function [parent=#WINGCOMMANDER] WingCommanderStatus
  -- @param #WINGCOMMANDER self

  --- Triggers the FSM event "SkipperStatus" after a delay.
  -- @function [parent=#WINGCOMMANDER] __WingCommanderStatus
  -- @param #WINGCOMMANDER self
  -- @param #number delay Delay in seconds.


  -- Debug trace.
  if false then
    self.Debug=true
    BASE:TraceOnOff(true)
    BASE:TraceClass(self.ClassName)
    BASE:TraceLevel(1)
  end
  self.Debug=true


  return self
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User functions
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Add an airwing to the wingcommander.
-- @param #WINGCOMMANDER self
-- @param Ops.AirWing#AIRWING Airwing The airwing to add.
-- @return #WINGCOMMANDER self
function WINGCOMMANDER:AddAirwing(Airwing)

  --table.insert(self.airwings, Airwing)
  
  self.airwings[Airwing.alias]=Airwing
  
  return self
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Start & Status
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- On after Start event. Starts the FLIGHTGROUP FSM and event handlers.
-- @param #WINGCOMMANDER self
-- @param Wrapper.Group#GROUP Group Flight group.
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function WINGCOMMANDER:onafterStart(From, Event, To)

  -- Short info.
  local text=string.format("Starting Wing Commander")
  self:I(self.lid..text)

  -- Start the status monitoring.
  self:__SitRep(-1)
end

--- On after "Sitrep" event.
-- @param #WINGCOMMANDER self
-- @param Wrapper.Group#GROUP Group Flight group.
-- @param #string From From state.
-- @param #string Event Event.
-- @param #string To To state.
function WINGCOMMANDER:onafterSitrep(From, Event, To)

  -- FSM state.
  local fsmstate=self:GetState()
  
  
  
  -- Short info.
  local text=string.format("No activities")


  local capabilities=self:CheckResources()
  
  -- Number of assets total, on mission, available
  -- Number of assets available of each mission type.
    
  
  self:I(self.lid..text)
  
  if DetectedGroupsUnknown then
  
  for _,_group in pairs(DetectedGroupsUnknown) do
    local group=_group --Wrapper.Group#GROUP
    
    if group and group:IsAlive() then
    
      local category=group:GetCategory()
      local attribute=group:GetAttribute()
      local threatlevel=group:GetThreatLevel()
      
      if category==Group.Category.AIRPLANE or category==Group.Category.HELICOPTER then
      
        if capability.INTERCEPT.Navail>0 then
        
          --TODO: Something like get closest AIRWING or squadron?
          --      Launch even from multiple airwings? Currently Navail is like this. 
          
        end
        
      elseif category==Group.Category.GROUND then
      
        --TODO: action depends on type
        -- AA/SAM ==> SEAD
        -- Tanks ==>
        -- Artillery ==>
        -- Infantry ==>
        -- 
                
        if attribute==GROUP.Attribute.GROUND_AAA or attribute==GROUP.Attribute.GROUND_SAM then
            
            --TODO: SEAD/DEAD
        
        end
        
      
      elseif category==Group.Category.SHIP then
      
        --TODO: ANTISHIP
      
      end
    
    
    end
    
  end
  
  
  end
  
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Resources
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Check resources.
-- @param #WINGCOMMANDER self
-- @return #table 
function WINGCOMMANDER:CheckResources()

  local capabilities={}
   
  for _,MissionType in pairs(AUFTRAG.Type) do
    capabilities[MissionType]=0
  
    for _,_airwing in pairs(self.airwings) do
      local airwing=_airwing --Ops.AirWing#AIRWING
        
      -- Get Number of assets that can do this type of missions.
      local _,nassets=airwing:CanMission(MissionType)
      
      -- Add up airwing resources.
      capabilities[MissionType]=capabilities[MissionType]+nassets
    end
  
  end

  return capabilities
end

--- Check all airwings if they are able to do a specific mission type at a certain location with a given number of assets.
-- @param #WINGCOMMANDER self
-- @return Ops.AirWing#AIRWING The airwing object best for this mission.
function WINGCOMMANDER:GetAirwingForMission(MissionType, Coordinate, Nassets)

  --TODO: run over all airwings. sort by distance and available assets.

end



