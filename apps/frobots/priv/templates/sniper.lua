---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by digitsu.
--- DateTime: 2021/12/01 11:28
---

--- sniper
--- goes to a random corner and scans for targets, moves if hit.
---
---
---
return function(state, ...)
  state = state or {}
  assert(
          type(state) == 'table',
          'Invalid state. Must receive a table'
  )
  math.randomseed( os.time() )
  math.random(); math.random(); math.random()
  state.type = "sniper"
  -- constants {corner x, corner y, scan angle from that corner}
  c1x = 50; c1y = 50; s1 = 0;
  c2x = 50; c2y = 950; s2 = 270;
  c3x = 950; c3y = 950; s3 = 180;
  c4x = 950; c4y = 50; s4 = 90;


  local function distance(x1,y1,x2,y2)
    local x = x1 -x2
    local y = y1 -y2
    local d = math.sqrt((x*x) + (y*y))
    return d
  end

  local function plot_course(xx,yy)
    local d
    local curx = loc_x()
    local cury = loc_y()
    local x = xx - curx
    local y = yy - cury

    if x == 0 then
      if yy > cury then
        d = 90.0
      else
        d = 270.0
      end
    else
      d = math.atan(y, x) * 180/math.pi
    end
    return d
  end

  local function corner()
    local x,y;
    local angle;
    local new;
    new = math.random(4)
    if (new == corner) then
      corner = (new + 1) % 4
    else
      corner = new % 4
    end

    if (corner == 0) then
      x = c1x
      y = c1y
      sc = s1
    elseif (corner == 1) then
      x = c2x
      y = c2y
      sc = s2
    elseif (corner == 2) then
      x = c3x
      y = c3y
      sc = s3
    elseif (corner == 3) then
      x = c4x
      y = c4y
      sc = s4
    end
    fudgex = -5 +math.random(10)
    fudgey = -5 +math.random(10)
    angle = plot_course(x + fudgex,y + fudgey)
    drive(angle, 100)
    return {angle,x,y,sc}
  end

  local function set_state_camping()
    state.status = "camping"
    state.d = damage()
    state.scan_dir = state.dest[4]
    state.camp_on_target = false
    state.camp_scanning = false
    state.target_pinged = false

  end

  local function set_state_cornering()
    state.status = "cornering"
    state.dest = corner()
    state.d = damage()
    state.scan_dir = state.dest[4]
    state.camp_on_target = false
    state.camp_scanning = false
    state.target_pinged = false
  end

  local function camp() -- this is the 'main' while loop
    if (state.d < damage()) then       -- check for damage incurred
      set_state_cornering()
      return state
    end

    if state.scan_dir < state.dest[4] + 90 then    --scan through 90 degree range
        range = scan(state.scan_dir, 3)          -- look at a direction
      if (range <= 700 and range > 0) then -- found someone in RANGE!
        state.target_pinged = true           -- set closest flag
        cannon(state.scan_dir + 1, range)        -- fire!
        cannon(state.scan_dir - 1, range)        -- fire!
        range = scan(state.scan_dir, 1)      -- check target again
        if range == 0 then
          state.scan_dir = state.scan_dir - 5  -- back up a bit on next scan
        end
      elseif state.target_pinged == true then -- last cycle we had someone in range
        state.scan_dir = state.scan_dir - 10        -- back up scan just in case
        state.target_pinged = false
      else
        state.scan_dir = state.scan_dir + 2           -- increment scan
      end
    else
        if (state.target_pinged == false) or state.scan_dir < 0 then       -- check for any targets in range
          set_state_cornering()  -- give up on this corner camp
        else
          state.scan_dir = state.dest[4]      -- targets were found in range, start again from beginning of scan degree
          state.target_pinged = false -- reset target found flag
        end
    end
  end

  if state.status == nil then
    set_state_cornering()
    state.timer = 30
  elseif state.status == "cornering" then
    if distance(loc_x(), loc_y(), state.dest[2],state.dest[3]) < 100 and speed() > 0 then
      state.status = "slowing"
      drive( state.dest[1], 20)
    else
      drive( state.dest[1], 100)
    end
  elseif state.status == "slowing" then
    state.timer = state.timer - 1
    if distance(loc_x(), loc_y(), state.dest[2],state.dest[3]) < 10 and speed() > 0 or state.timer < 0 then
      drive(0, 0)
      state.timer = 30
      set_state_camping()
    end
  elseif state.status == "camping" then
    camp(state)
  end
  return state
end
