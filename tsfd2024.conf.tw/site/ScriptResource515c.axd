﻿// Name:        HoverExtender.HoverBehavior.debug.js
// Assembly:    AjaxControlToolkit
// Version:     4.1.7.725
// FileVersion: 4.1.7.0725
// (c) 2010 CodePlex Foundation



/// <reference name="MicrosoftAjax.debug.js" />
/// <reference path="../ExtenderBase/BaseScripts.js" />
/// <reference path="../Common/Common.js" />

(function() {
var scriptName = "ExtendedHover";

function execute() {

Type.registerNamespace('Sys.Extended.UI');

Sys.Extended.UI.HoverBehavior = function(element) {
    /// <param name="element">The DOM element the behavior is associated with.</param>
    Sys.Extended.UI.HoverBehavior.initializeBase(this, [element]);
    
    this._elementHandlers = null;
    this._hoverElementHandlers = null;
    
    this._hoverElement = null;
    this._hoverCount = 0;
    this._unhoverDelay = 0;
    this._hoverDelay = 0;
    this._hoverScript = null;
    this._unhoverScript = null;   
    this._hoverFired = false; 
}
    
Sys.Extended.UI.HoverBehavior.prototype = {
    _setupHandlersArray: function() {
        var target = [];        
        target[0] = Function.createDelegate(this, this._onHover);                
        target[1] = Function.createDelegate(this, this._onUnhover);        
        return target;
    },
    
    get_elementHandlers: function() {
        
        if (!this._elementHandlers) {
            this._elementHandlers = this._setupHandlersArray();
        }
        return this._elementHandlers;
    },
    
    get_hoverElementHandlers: function() {
        
        if (!this._hoverElementHandlers) {
            this._hoverElementHandlers = this._setupHandlersArray();
        }
        return this._hoverElementHandlers;
    },

    get_hoverElement: function() {        
        /// <value type="Object">Dom element associated with this behavior.</value>       
       
        return this._hoverElement;
    },
    
    set_hoverElement: function(element) {
        /// <param name="element" type="Object">Dom element associated with this behavior.</param>
                
        if (element != this._hoverElement) {
            
            if (this._hoverElement) {
                this._setupHandlers(this._hoverElement, this.get_hoverElementHandlers(), false);
            }
            
            this._hoverElement = element;
            
            if (this._hoverElement) {
                this._setupHandlers(this._hoverElement, this.get_hoverElementHandlers(), true);
            }            
        }
    },
    
    get_hoverDelay: function() {
        /// <value type="Number">Delay in milliseconds before unhover event is raised.</value>
        return this._hoverDelay;
    },
    
    set_hoverDelay: function(value) {
        /// <param name="value" type="Number">Delay in milliseconds before unhover event is raised.</param>
        this._hoverDelay = value;
        this.raisePropertyChanged('hoverDelay');
    },
    
    get_hoverScript: function() {
        return this._hoverScript;
    },
    
    set_hoverScript : function(script) {
        this._hoverScript = script;
    },
    
    get_unhoverDelay: function() {
        /// <value type="Number">Delay in milliseconds before unhover event is raised.</value>
        return this._unhoverDelay;
    },
    
    set_unhoverDelay: function(value) {
        /// <param name="value" type="Number">Delay in milliseconds before unhover event is raised.</param>
        this._unhoverDelay = value;
        this.raisePropertyChanged('unhoverDelay');
    },
    
    get_unhoverScript: function() {
        return this._unhoverScript;
    },
    
    set_unhoverScript : function(script) {
        this._unhoverScript = script;
    },

    dispose: function() {
        var element = this.get_element();
        
        if (this._elementHandlers) {
            var handlers = this.get_elementHandlers();
            this._setupHandlers(element, handlers, false);
            this._elementHandlers = null;
        }
       
        if(this._hoverElement) {
            var handlers = this.get_hoverElementHandlers();
            this._setupHandlers(this._hoverElement, handlers, false);
            this._hoverElement = null;
        }        
        Sys.Extended.UI.HoverBehavior.callBaseMethod(this, 'dispose');
    },

    initialize: function() {
        Sys.Extended.UI.HoverBehavior.callBaseMethod(this, 'initialize');
        
        var handlers = this.get_elementHandlers();
        
        this._setupHandlers(this.get_element(), handlers, true);
        
        if (this._hoverElement) {
            handlers = this.get_hoverElementHandlers();
            this._setupHandlers(this._hoverElement, handlers, true);
        }
    },

    add_hover: function(handler) {
        this.get_events().addHandler("hover", handler);
    },

    remove_hover: function(handler) {
        this.get_events().removeHandler("hover", handler);
    },
    
    _fireHover : function() {
    
        if (!this._hoverCount || this._hoverFired) {
            return;
        }
        
        var handler = this.get_events().getHandler("hover");
        if (handler) {
            handler(this, Sys.EventArgs.Empty);
        }
        if (this._hoverScript) {
            eval(this._hoverScript);
        }
        this._hoverFired = true;
    },
    
    _onHover: function() {
        this._hoverCount++;
        
        if (!this._hoverDelay) {
            this._fireHover();
        }
        else {
            window.setTimeout(Function.createDelegate(this, this._fireHover), this._hoverDelay);
        }
    },

    add_unhover: function(handler) {
        this.get_events().addHandler("unhover", handler);
    },
    
    remove_unhover: function(handler) {
        this.get_events().removeHandler("unhover", handler);
    },
    
    _fireUnhover : function() {
        if (this._hoverFired && !this._hoverCount) {
            this._hoverFired = false;
            var handler = this.get_events().getHandler("unhover");
            if (handler) {
                handler(this, Sys.EventArgs.Empty);
            }
            if (this._unhoverScript) {
                eval(this._unhoverScript);
            }                  
        }
    },
    
    _onUnhover: function() {
        this._hoverCount--;
  
        if (this._hoverCount <= 0) {
        
            this._hoverCount = 0;   
        
            if (!this._unhoverDelay) {
                this._fireUnhover();
            }
            else {
                window.setTimeout(Function.createDelegate(this, this._fireUnhover), this._unhoverDelay);
            }       
            
        }
    },
    
    _setupHandlers: function(element, handlers, hookup) {        
    
        if (!this.get_isInitialized() || !element) return;
        
        if (hookup) {
            $addHandler(element, "mouseover", handlers[0]);        
            $addHandler(element, "focus", handlers[0]);        
            $addHandler(element, "mouseout", handlers[1]);        
            $addHandler(element, "blur", handlers[1]);
        }
        else {
            $removeHandler(element, "mouseover", handlers[0]);        
            $removeHandler(element, "focus", handlers[0]);        
            $removeHandler(element, "mouseout", handlers[1]);        
            $removeHandler(element, "blur", handlers[1]);
        }            
    }
}
Sys.Extended.UI.HoverBehavior.descriptor = {
    properties: [   {name: 'hoverElement', isDomElement: true},
                    {name: 'unhoverDelay', type: Number} ],
    events: [   {name: 'hover'},
                {name: 'unhover'} ]
}
Sys.Extended.UI.HoverBehavior.registerClass('Sys.Extended.UI.HoverBehavior', Sys.Extended.UI.BehaviorBase);
Sys.registerComponent(Sys.Extended.UI.HoverBehavior, { name: "hover" });

} // execute

if (window.Sys && Sys.loader) {
    Sys.loader.registerScript(scriptName, ["ExtendedBase", "ExtendedCommon"], execute);
}
else {
    execute();
}

})();
