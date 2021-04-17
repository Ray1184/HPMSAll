---
--- Created by Ray1184.
--- DateTime: 04/11/2020 17:04
---
--- Utilities for preset actions flow.
--- Input example:
--- workflow = {
---               {0,     0,      function()              disable_input()       end                                  },
---               {0,     5000,   function(actor)         actor:move_dir(5)     end,    get_player()                 },
---               {5001,  20000,  function(actor)         actor:rest()          end,    get_player()                 },
---               {5001,  15000,  function(actor, text)   msg(actor, text)      end,    get_player(), 'Hello!'       },
---               {10000, 20000,  function(actor, pos)    actor:move_to(pos)    end,    npc1,         {1.0, 0.0, 2.5}},
---               {20000, 20000,  function()              enable_input()        end                                  }
---            }
--- workflow.execute(workflow}
---

local lib = require('data/scripts/libs/HPMSFacade')