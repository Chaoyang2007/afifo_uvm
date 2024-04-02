`ifndef AFIFO_ENV_PROP__SV
`define AFIFO_ENV_PROP__SV

// class define, env porperties
class afifo_env_prop extends uvm_object;

    afifo_agent_prop wagt_prop;
    afifo_agent_prop ragt_prop;

    function new(string name="afifo_env_prop");
        super.new(name);
    endfunction

    `uvm_object_utils(afifo_env_prop)
endclass:afifo_env_prop

`endif // AFIFO_ENV_PROP__SV