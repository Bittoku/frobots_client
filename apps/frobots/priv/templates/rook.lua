---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by digitsu.
--- DateTime: 2022/01/15 15:36
---
--- rook.lua
--- rook moves in columns, scanning and attacking targets. Moves horizontally only, but scans vertically and horizontally

return function(state, ...)
    state = state or {}
    state.type = "rook"



    local function point_right()
        state.course = 0
    end

    local function point_left()
        state.course = 180
    end

    local function pointing_right()
        return state.course == 0
    end
    local function pointing_left()
        return state.course == 180
    end
    local function close_to_right_wall()
        return loc_x() > 950
    end
    local function close_to_left_wall()
        return loc_x() < 50
    end

    local function drive_down(speed)
        return drive(90,speed)
    end
    local function drive_up(speed)
        return drive(270, speed)
    end
    local function in_upper_half()
        return loc_y() < 500
    end
    local function in_lower_half()
        return loc_y() > 500
    end
    local function stop()
        return drive(0,0)
    end
    local function approaching_horiz_from_above()
        return state.rank - loc_y() < 20
    end
    local function approaching_horiz_from_below()
        return loc_y() - state.rank < 20
    end
    local function approaching_right_wall()
        return loc_x() > 900
    end
    local function approaching_left_wall()
        return loc_x() < 100
    end

    local function state_uninitialized()
        return state.status == nil
    end
    local function state_ranking()
        return state.status == "ranking"
    end
    local function state_filing()
        return state.status == "filing"
    end
    local function state_shooting()
        return state.status == "shooting"
    end
    local function state_running()
        return state.status == "running"
    end
    local function set_state(new_status)
        state.status = new_status
    end

    local function was_damaged()
        return state.d < damage()
    end

    local function change()
        if pointing_right() then
            point_left()
        else
            point_right()
        end
    end
    local function out_of_range(range)
       return (range == 0 or range > 700)
    end
    local function set_rank(rank)
        state.rank = rank
    end


    local function init()
        -- init some starting parameters
        state.d = damage()
        state.course = 0
        state.boundary = 990
        state.status = "ranking"
        state.last_look = 0
        state.rank = math.random(300,700)
        state.ran_from = loc_x()
    end

    -- look somewhere and fire cannon repeatedly at in-range targets
    local function look(deg)
        range = scan(deg, 2)
        state.last_look = deg
        if (range > 0 and range <= 700) then
            cannon(deg, range)
            stop()
            set_state("shooting")
            state.target_range = range
            return state
        end
    end

    if state_uninitialized() then
        init()
    -- move to the center of the board
    elseif state_ranking() then
        if( in_upper_half() ) then
            drive_down(70)
            if approaching_horiz_from_above() then
                stop()
                set_state("filing")
            end
        else
            drive_up(70)
            if approaching_horiz_from_below() then
                stop()
                set_state("filing")
            end
        end
    elseif state_filing() then
        drive( state.course, 30 )
        look(state.last_look + 90)

        if pointing_right() then
            if close_to_right_wall() or speed() == 0 then
                change()
            end
        else
            if close_to_left_wall() or speed() == 0 then
                change()
            end
        end
    elseif state_shooting() then
        cannon(state.last_look, state.target_range)
        state.target_range = scan(state.last_look, 2)
        cannon(state.last_look, state.target_range)
        if out_of_range(state.target_range) then
            set_state("filing")
            state.target_range = 0
        end
    elseif state_running() then
        if math.abs(loc_x() - state.ran_from) > 50 or close_to_left_wall() or close_to_right_wall() then
            stop()
            change()
            if in_upper_half() then
                set_rank(math.random(10, 100))
            else
                set_rank(-math.random(10,100))
            end
            set_state("ranking")
            state.d = damage() -- reset the damage threshold
            state.ran_from = loc_x()
            return state
        end
        if approaching_left_wall() or approaching_right_wall() then
            drive(state.course, 20)
        else
            drive(state.course, 100)
        end
    end

    if was_damaged() and not state_running() then
        set_state("running")
        state.d = damage()
        state.ran_from = loc_x()
        change()
    end
    return state
end