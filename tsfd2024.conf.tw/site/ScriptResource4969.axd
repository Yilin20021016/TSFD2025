﻿// Name:        ModalPopup.ModalPopupBehavior.debug.js
// Assembly:    AjaxControlToolkit
// Version:     4.1.7.725
// FileVersion: 4.1.7.0725
// (c) 2010 CodePlex Foundation



/// <reference name="MicrosoftAjax.debug.js" />
/// <reference name="MicrosoftAjaxTimer.debug.js" />
/// <reference name="MicrosoftAjaxWebForms.debug.js" />
/// <reference path="../ExtenderBase/BaseScripts.js" />
/// <reference path="../Common/Common.js" />
/// <reference path="../DynamicPopulate/DynamicPopulateBehavior.js" />
/// <reference path="../RoundedCorners/RoundedCornersBehavior.js" />
/// <reference path="../Compat/Timer/Timer.js" />
/// <reference path="../DropShadow/DropShadowBehavior.js" />
/// <reference path="../Compat/DragDrop/DragDropScripts.js" />
/// <reference path="../DragPanel/FloatingBehavior.js" />


Type.registerNamespace('Sys.Extended.UI');

Sys.Extended.UI.ModalPopupRepositionMode = function () {
    /// <summary>
    /// The ModalPopupRepositionMode enumeration describes how the modal popup repositions
    /// </summary>
    /// <field name="None" type="Number" integer="true" />
    /// <field name="RepositionOnWindowResize" type="Number" integer="true" />
    /// <field name="RepositionOnWindowScroll" type="Number" integer="true" />
    /// <field name="RepositionOnWindowResizeAndScroll" type="Number" integer="true" />
    throw Error.invalidOperation();
};
Sys.Extended.UI.ModalPopupRepositionMode.prototype = {
    None: 0,
    RepositionOnWindowResize: 1,
    RepositionOnWindowScroll: 2,
    RepositionOnWindowResizeAndScroll: 3
};
Sys.Extended.UI.ModalPopupRepositionMode.registerEnum('Sys.Extended.UI.ModalPopupRepositionMode');


Sys.Extended.UI.ModalPopupBehavior = function (element) {
    /// <summary>
    /// The ModalPopupBehavior is used to display the target element as a modal dialog
    /// </summary>
    /// <param name="element" type="Sys.UI.DomElement" domElement="true">
    /// DOM Element the behavior is associated with
    /// </param>
    Sys.Extended.UI.ModalPopupBehavior.initializeBase(this, [element]);

    this._PopupControlID = null;
    this._PopupDragHandleControlID = null;
    this._BackgroundCssClass = null;
    this._DropShadow = false;
    this._Drag = false;
    this._OkControlID = null;
    this._CancelControlID = null;
    this._OnOkScript = null;
    this._OnCancelScript = null;
    this._xCoordinate = -1;
    this._yCoordinate = -1;
    this._repositionMode = Sys.Extended.UI.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll;
    this._onShown = new Sys.Extended.UI.Animation.GenericAnimationBehavior(element); //element replaced later with popuptarget
    this._onHidden = new Sys.Extended.UI.Animation.GenericAnimationBehavior(element);
    this._onShowing = new Sys.Extended.UI.Animation.GenericAnimationBehavior(element);
    this._onHiding = new Sys.Extended.UI.Animation.GenericAnimationBehavior(element);

    this._backgroundElement = null;
    this._foregroundElement = null;
    this._relativeOrAbsoluteParentElement = null;
    this._popupElement = null;
    this._dragHandleElement = null;
    this._showHandler = null;
    this._okHandler = null;
    this._cancelHandler = null;
    this._scrollHandler = null;
    this._resizeHandler = null;
    this._windowHandlersAttached = false;
    this._dropShadowBehavior = null;
    this._dragBehavior = null;
    this._isIE6 = false;

    this._saveTabIndexes = new Array();
    this._saveDesableSelect = new Array();
    this._tagWithTabIndex = new Array('A', 'AREA', 'BUTTON', 'INPUT', 'OBJECT', 'SELECT', 'TEXTAREA', 'IFRAME');

    this._isAnimationJustEnded = false;
    this._hidingAnimationEndedHandler = null;
    this._showingAnimationEndedHandler = null;

};
Sys.Extended.UI.ModalPopupBehavior.prototype = {
    initialize: function () {
        /// <summary>
        /// Initialize the behavior
        /// </summary>

        /*
        <div superpopup - drag container resizable><div -- drag handle\dropshadow foreground></div></div>
        */
        Sys.Extended.UI.ModalPopupBehavior.callBaseMethod(this, 'initialize');
        this._isIE6 = (Sys.Browser.agent == Sys.Browser.InternetExplorer && Sys.Browser.version < 7);
        if (this._PopupDragHandleControlID)
            this._dragHandleElement = $get(this._PopupDragHandleControlID);

        this._popupElement = $get(this._PopupControlID);
        if (this._DropShadow) {
            this._foregroundElement = document.createElement('div');
            this._foregroundElement.id = this.get_id() + '_foregroundElement';
            this._popupElement.parentNode.appendChild(this._foregroundElement);
            this._foregroundElement.appendChild(this._popupElement);
        }
        else {
            this._foregroundElement = this._popupElement;
        }
        this._backgroundElement = document.createElement('div');
        this._backgroundElement.id = this.get_id() + '_backgroundElement';
        this._backgroundElement.style.display = 'none';
        this._backgroundElement.style.position = 'fixed';
        this._backgroundElement.style.left = '0px';
        this._backgroundElement.style.top = '0px';
        this._backgroundElement.style.zIndex = 10000;
        if (this._BackgroundCssClass) {
            this._backgroundElement.className = this._BackgroundCssClass;
        }
        this._foregroundElement.parentNode.appendChild(this._backgroundElement);

        this._foregroundElement.style.display = 'none';
        this._foregroundElement.style.position = 'fixed';
        this._foregroundElement.style.zIndex = $common.getCurrentStyle(this._backgroundElement, 'zIndex', this._backgroundElement.style.zIndex) + 1;

        this._showHandler = Function.createDelegate(this, this._onShow);
        $addHandler(this.get_element(), 'click', this._showHandler);

        if (this._OkControlID) {
            this._okHandler = Function.createDelegate(this, this._onOk);
            $addHandler($get(this._OkControlID), 'click', this._okHandler);
        }

        if (this._CancelControlID) {
            this._cancelHandler = Function.createDelegate(this, this._onCancel);
            $addHandler($get(this._CancelControlID), 'click', this._cancelHandler);
        }

        this._scrollHandler = Function.createDelegate(this, this._onLayout);
        this._resizeHandler = Function.createDelegate(this, this._onLayout);

        this.registerPartialUpdateEvents();

        this._resetAnimationsTarget();

        if (this._onHiding.get_animation()) {
            this._hidingAnimationEndedHandler = Function.createDelegate(this, function () {
                this._isAnimationJustEnded = true;
                this.hide();
            });
            this._onHiding.get_animation().add_ended(this._hidingAnimationEndedHandler);
        }

        if (this._onShowing.get_animation()) {
            this._showingAnimationEndedHandler = Function.createDelegate(this, function () {
                this._isAnimationJustEnded = true;
                this.show();
            });
            this._onShowing.get_animation().add_ended(this._showingAnimationEndedHandler);
        }
    },

    dispose: function () {
        /// <summary>
        /// Dispose the behavior
        /// </summary>

        this._hideImplementation();

        if (this._foregroundElement && this._foregroundElement.parentNode) {
            this._foregroundElement.parentNode.removeChild(this._backgroundElement);

            if (this._DropShadow) {
                this._foregroundElement.parentNode.appendChild(this._popupElement);
                this._foregroundElement.parentNode.removeChild(this._foregroundElement);
            }
        }

        this._scrollHandler = null;
        this._resizeHandler = null;
        if (this._cancelHandler && $get(this._CancelControlID)) {
            $removeHandler($get(this._CancelControlID), 'click', this._cancelHandler);
            this._cancelHandler = null;
        }
        if (this._okHandler && $get(this._OkControlID)) {
            $removeHandler($get(this._OkControlID), 'click', this._okHandler);
            this._okHandler = null;
        }
        if (this._showHandler) {
            $removeHandler(this.get_element(), 'click', this._showHandler);
            this._showHandler = null;
        }

        if (this._hidingAnimationEndedHandler) {
            this._onHiding.get_animation().remove_ended(this._hidingAnimationEndedHandler);
        }

        if (this._showingAnimationEndedHandler) {
            this._onShowing.get_animation().remove_ended(this._showingAnimationEndedHandler);
        }

        Sys.Extended.UI.ModalPopupBehavior.callBaseMethod(this, 'dispose');
    },

    _attachPopup: function () {
        /// <summary>
        /// Attach the event handlers for the popup
        /// </summary>

        if (this._DropShadow && !this._dropShadowBehavior) {
            this._dropShadowBehavior = $create(Sys.Extended.UI.DropShadowBehavior, {}, null, null, this._popupElement);
        }
        if (this._dragHandleElement && !this._dragBehavior) {
            this._dragBehavior = $create(Sys.Extended.UI.FloatingBehavior, { "handle": this._dragHandleElement }, null, null, this._foregroundElement);
        }

        $addHandler(window, 'resize', this._resizeHandler);
        $addHandler(window, 'scroll', this._scrollHandler);
        this._windowHandlersAttached = true;
    },

    _detachPopup: function () {
        /// <summary>
        /// Detach the event handlers for the popup
        /// </summary>

        if (this._windowHandlersAttached) {
            if (this._scrollHandler) {
                $removeHandler(window, 'scroll', this._scrollHandler);
            }
            if (this._resizeHandler) {
                $removeHandler(window, 'resize', this._resizeHandler);
            }
            this._windowHandlersAttached = false;
        }

        if (this._dragBehavior) {
            this._dragBehavior.dispose();
            this._dragBehavior = null;
        }

        if (this._dropShadowBehavior) {
            this._dropShadowBehavior.dispose();
            this._dropShadowBehavior = null;
        }
    },

    _onShow: function (e) {
        /// <summary>
        /// Handler for the target's click event
        /// </summary>
        /// <param name="e" type="Sys.UI.DomEvent">
        /// Event info
        /// </param>

        if (!this.get_element().disabled) {
            this.show();
            e.preventDefault();
            return false;
        }
    },

    _onOk: function (e) {
        /// <summary>
        /// Handler for the modal dialog's OK button click
        /// </summary>
        /// <param name="e" type="Sys.UI.DomEvent">
        /// Event info
        /// </param>

        var element = $get(this._OkControlID);
        if (element && !element.disabled) {
            if (this.hide() && this._OnOkScript) {
                window.setTimeout(this._OnOkScript, 0);
            }
            e.preventDefault();
            return false;
        }
    },

    _onCancel: function (e) {
        /// <summary>
        /// Handler for the modal dialog's Cancel button click
        /// </summary>
        /// <param name="e" type="Sys.UI.DomEvent">
        /// Event info
        /// </param>

        var element = $get(this._CancelControlID);
        if (element && !element.disabled) {
            if (this.hide() && this._OnCancelScript) {
                window.setTimeout(this._OnCancelScript, 0);
            }
            e.preventDefault();
            return false;
        }
    },

    _onLayout: function (e) {
        /// <summary>
        /// Handler for scrolling and resizing events that would require a repositioning of the modal dialog
        /// </summary>
        /// <param name="e" type="Sys.UI.DomEvent">
        /// Event info
        /// </param>
        var positioning = this.get_repositionMode();
        if (((positioning === Sys.Extended.UI.ModalPopupRepositionMode.RepositionOnWindowScroll) ||
            (positioning === Sys.Extended.UI.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll)) && (e.type === 'scroll')) {
            this._layout();
        } else if (((positioning === Sys.Extended.UI.ModalPopupRepositionMode.RepositionOnWindowResize) ||
            (positioning === Sys.Extended.UI.ModalPopupRepositionMode.RepositionOnWindowResizeAndScroll)) && (e.type === 'resize')) {
            this._layout();
        } else {
            this._layoutBackgroundElement();
        }
    },

    show: function () {
        /// <summary>
        /// Display the element referenced by PopupControlID as a modal dialog
        /// </summary>

        if (!this._isAnimationJustEnded) {
            var eventArgs = new Sys.CancelEventArgs();
            this.raiseShowing(eventArgs);
            if (eventArgs.get_cancel()) {
                return;
            }
            else if (this._onShowing.get_animation()) {
                this._onShowing.play();
                return;
            }
        }
        else {
            this._isAnimationJustEnded = false;
        }

        this.populate();
        this._attachPopup();

        this._backgroundElement.style.display = '';
        this._foregroundElement.style.display = '';
        this._popupElement.style.display = '';
        if (this._isIE6) {
            this._foregroundElement.style.position = 'absolute';
            this._backgroundElement.style.position = 'absolute';
            var tempRelativeOrAbsoluteParent = this._foregroundElement.parentNode;
            while (tempRelativeOrAbsoluteParent && (tempRelativeOrAbsoluteParent != document.documentElement)) {
                if ((tempRelativeOrAbsoluteParent.style.position != 'relative') && (tempRelativeOrAbsoluteParent.style.position != 'absolute')) {
                    tempRelativeOrAbsoluteParent = tempRelativeOrAbsoluteParent.parentNode;
                } else {
                    this._relativeOrAbsoluteParentElement = tempRelativeOrAbsoluteParent;
                    break;
                }
            }
        }


        this.disableTab();

        this._layout();
        this._layout();

        this.raiseShown(Sys.EventArgs.Empty);

        this._onShown.play();
    },

    disableTab: function () {
        /// <summary>
        /// Change the tab indices so we only tab through the modal popup
        /// (and hide SELECT tags in IE6)
        /// </summary>

        var i = 0;
        var tagElements;
        var tagElementsInPopUp = new Array();
        Array.clear(this._saveTabIndexes);

        for (var j = 0; j < this._tagWithTabIndex.length; j++) {
            tagElements = this._foregroundElement.getElementsByTagName(this._tagWithTabIndex[j]);
            for (var k = 0; k < tagElements.length; k++) {
                tagElementsInPopUp[i] = tagElements[k];
                i++;
            }
        }

        i = 0;
        for (var j = 0; j < this._tagWithTabIndex.length; j++) {
            tagElements = document.getElementsByTagName(this._tagWithTabIndex[j]);
            for (var k = 0; k < tagElements.length; k++) {
                if (Array.indexOf(tagElementsInPopUp, tagElements[k]) == -1) {
                    this._saveTabIndexes[i] = { tag: tagElements[k], index: tagElements[k].tabIndex };
                    tagElements[k].tabIndex = "-1";
                    i++;
                }
            }
        }

        i = 0;
        if ((Sys.Browser.agent === Sys.Browser.InternetExplorer) && (Sys.Browser.version < 7)) {
            var tagSelectInPopUp = new Array();
            for (var j = 0; j < this._tagWithTabIndex.length; j++) {
                tagElements = this._foregroundElement.getElementsByTagName('SELECT');
                for (var k = 0; k < tagElements.length; k++) {
                    tagSelectInPopUp[i] = tagElements[k];
                    i++;
                }
            }

            i = 0;
            Array.clear(this._saveDesableSelect);
            tagElements = document.getElementsByTagName('SELECT');
            for (var k = 0; k < tagElements.length; k++) {
                if (Array.indexOf(tagSelectInPopUp, tagElements[k]) == -1) {
                    this._saveDesableSelect[i] = { tag: tagElements[k], visib: $common.getCurrentStyle(tagElements[k], 'visibility') };
                    tagElements[k].style.visibility = 'hidden';
                    i++;
                }
            }
        }
    },

    restoreTab: function () {
        /// <summary>
        /// Restore the tab indices so we tab through the page like normal
        /// (and restore SELECT tags in IE6)
        /// </summary>

        for (var i = 0; i < this._saveTabIndexes.length; i++) {
            this._saveTabIndexes[i].tag.tabIndex = this._saveTabIndexes[i].index;
        }
        Array.clear(this._saveTabIndexes);

        if ((Sys.Browser.agent === Sys.Browser.InternetExplorer) && (Sys.Browser.version < 7)) {
            for (var k = 0; k < this._saveDesableSelect.length; k++) {
                this._saveDesableSelect[k].tag.style.visibility = this._saveDesableSelect[k].visib;
            }
            Array.clear(this._saveDesableSelect);
        }
    },

    hide: function () {
        /// <summary>
        /// Hide the modal dialog
        /// </summary>
        /// <returns type="Boolean" mayBeNull="false">
        /// Whether or not the dialog was hidden
        /// </returns>

        if (!this._isAnimationJustEnded) {
            var eventArgs = new Sys.CancelEventArgs();
            this.raiseHiding(eventArgs);
            if (eventArgs.get_cancel()) {
                return false;
            }
            else if (this._onHiding.get_animation()) {
                this._onHiding.play();
                return true;
            }
        }
        else {
            this._isAnimationJustEnded = false;
        }

        this._hideImplementation();

        this.raiseHidden(Sys.EventArgs.Empty);

        this._onHidden.play();

        return true;
    },

    _hideImplementation: function () {
        /// <summary>
        /// Internal implementation to hide the modal dialog
        /// </summary>

        this._backgroundElement.style.display = 'none';
        this._foregroundElement.style.display = 'none';

        this.restoreTab();

        this._detachPopup();
    },

    _layout: function () {
        /// <summary>
        /// Position the modal dialog 
        /// </summary>
        var scrollLeft = (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft);
        var scrollTop = (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

        var clientBounds = $common.getClientBounds();
        var clientWidth = clientBounds.width;
        var clientHeight = clientBounds.height;

        this._layoutBackgroundElement();

        var xCoord = 0;
        var yCoord = 0;
        if (this._xCoordinate < 0) {
            var foregroundelementwidth = this._foregroundElement.offsetWidth ? this._foregroundElement.offsetWidth : this._foregroundElement.scrollWidth;
            xCoord = ((clientWidth - foregroundelementwidth) / 2);
            if (this._foregroundElement.style.position == 'absolute') {
                xCoord += scrollLeft;
            }
            this._foregroundElement.style.left = xCoord + 'px';

        } else {
            if (this._isIE6) {
                this._foregroundElement.style.left = (this._xCoordinate + scrollLeft) + 'px';
                xCoord = this._xCoordinate + scrollLeft;
            }
            else {
                this._foregroundElement.style.left = this._xCoordinate + 'px';
                xCoord = this._xCoordinate;
            }
        }
        if (this._yCoordinate < 0) {
            var foregroundelementheight = this._foregroundElement.offsetHeight ? this._foregroundElement.offsetHeight : this._foregroundElement.scrollHeight;
            yCoord = ((clientHeight - foregroundelementheight) / 2);
            if (this._foregroundElement.style.position == 'absolute') {
                yCoord += scrollTop;
            }
            this._foregroundElement.style.top = yCoord + 'px';

        } else {
            if (this._isIE6) {
                this._foregroundElement.style.top = (this._yCoordinate + scrollTop) + 'px';
                yCoord = this._yCoordinate + scrollTop;
            }
            else {
                this._foregroundElement.style.top = this._yCoordinate + 'px';
                yCoord = this._yCoordinate;
            }
        }

        this._layoutForegroundElement(xCoord, yCoord);

        if (this._dropShadowBehavior) {
            this._dropShadowBehavior.setShadow();
            window.setTimeout(Function.createDelegate(this, this._fixupDropShadowBehavior), 0);
        }

        this._layoutBackgroundElement();
    },

    _layoutForegroundElement: function (xCoord, yCoord) {
        /// <summary>
        /// Set the correct location of the foreground element to ensure that it is absolutely 
        /// positioned with respect to the browser. This is just a workaround for IE 6 since
        /// elements nested in relative parents cause modal popup positioning issues and 'fixed'
        /// is not supported by IE 6. Hence we manually compute the right location of the popup.
        /// </summary>
        /// <param name="xCoord" type="Number" integer="true" maybenull="false">
        /// <param name="yCoord" type="Number" integer="true" maybenull="false">        
        /// </params>

        if (this._isIE6 && this._relativeOrAbsoluteParentElement) {
            var foregroundLocation = $common.getLocation(this._foregroundElement);
            var relativeParentLocation = $common.getLocation(this._relativeOrAbsoluteParentElement);
            var getLocationXCoord = foregroundLocation.x;
            if (getLocationXCoord != xCoord) {
                this._foregroundElement.style.left = (xCoord - relativeParentLocation.x) + 'px';
            }

            var getLocationYCoord = foregroundLocation.y;
            if (getLocationYCoord != yCoord) {
                this._foregroundElement.style.top = (yCoord - relativeParentLocation.y) + 'px';
            }
        }
    },

    _layoutBackgroundElement: function () {
        /// <summary>
        /// Set the correct location of the background element to ensure that it is absolutely 
        /// positioned with respect to the browser.
        /// </summary>

        if (this._isIE6) {
            var backgroundLocation = $common.getLocation(this._backgroundElement);
            var backgroundXCoord = backgroundLocation.x;
            if (backgroundXCoord != 0) {
                this._backgroundElement.style.left = (-backgroundXCoord) + 'px';
            }

            var backgroundYCoord = backgroundLocation.y;
            if (backgroundYCoord != 0) {
                this._backgroundElement.style.top = (-backgroundYCoord) + 'px';
            }
        }
        var clientBounds = $common.getClientBounds();
        var clientWidth = clientBounds.width;
        var clientHeight = clientBounds.height;
        this._backgroundElement.style.width = Math.max(Math.max(document.documentElement.scrollWidth, document.body.scrollWidth), clientWidth) + 'px';
        this._backgroundElement.style.height = Math.max(Math.max(document.documentElement.scrollHeight, document.body.scrollHeight), clientHeight) + 'px';
    },

    _fixupDropShadowBehavior: function () {
        /// <summary>
        /// Some browsers don't update the location values immediately, so
        /// the location of the drop shadow would always be a step behind
        /// without this method
        /// </summary>

        if (this._dropShadowBehavior) {
            this._dropShadowBehavior.setShadow();
        }
    },

    _partialUpdateEndRequest: function (sender, endRequestEventArgs) {
        /// <summary>
        /// Show the popup if requested during a partial postback
        /// </summary>
        /// <param name="sender" type="Object">
        /// Sender
        /// </param>
        /// <param name="endRequestEventArgs" type="Sys.WebForms.EndRequestEventArgs">
        /// Event arguments
        /// </param>
        /// <returns />
        Sys.Extended.UI.ModalPopupBehavior.callBaseMethod(this, '_partialUpdateEndRequest', [sender, endRequestEventArgs]);

        if (this.get_element()) {
            var action = endRequestEventArgs.get_dataItems()[this.get_element().id];
            if ("show" == action) {
                this.show();
            } else if ("hide" == action) {
                this.hide();
            }
        }

        this._layout();
    },

    _onPopulated: function (sender, eventArgs) {
        /// <summary>
        /// Re-layout the popup after we've dynamically populated
        /// </summary>
        /// <param name="sender" type="Object">
        /// Sender
        /// </param>
        /// <param name="eventArgs" type="Sys.EventArgs">
        /// Event arguments
        /// </param>
        /// <returns />
        Sys.Extended.UI.ModalPopupBehavior.callBaseMethod(this, '_onPopulated', [sender, eventArgs]);

        this._layout();
    },

    _replaceAnimationTarget: function (memberName, target) {
        var json = this[memberName].get_json();
        this[memberName] = new Sys.Extended.UI.Animation.GenericAnimationBehavior(target);
        this[memberName].set_json(json);
        this[memberName].initialize();
    },

    _resetAnimationsTarget: function () {

        var target = $get(this.get_PopupControlID());

        this._replaceAnimationTarget('_onShowing', target);
        this._replaceAnimationTarget('_onShown', target);
        this._replaceAnimationTarget('_onHiding', target);
        this._replaceAnimationTarget('_onHidden', target);
    },

    get_PopupControlID: function () {
        /// <value type="String">
        /// The ID of the element to display as a modal popup
        /// </value>
        return this._PopupControlID;
    },
    set_PopupControlID: function (value) {
        if (this._PopupControlID != value) {
            this._PopupControlID = value;
            this.raisePropertyChanged('PopupControlID');
        }
    },

    get_X: function () {
        /// <value type="Number" integer="true">
        /// The number of pixels from the left of the browser to position the modal popup.
        /// </value>
        return this._xCoordinate;
    },
    set_X: function (value) {
        if (this._xCoordinate != value) {
            this._xCoordinate = value;
            this.raisePropertyChanged('X');
        }
    },

    get_Y: function () {
        /// <value type="Number" integer="true">
        /// The number of pixels from the top of the browser to position the modal popup.
        /// </value>
        return this._yCoordinate;
    },
    set_Y: function (value) {
        if (this._yCoordinate != value) {
            this._yCoordinate = value;
            this.raisePropertyChanged('Y');
        }
    },

    get_PopupDragHandleControlID: function () {
        /// <value type="String">
        /// The ID of the element to display as the drag handle for the modal popup
        /// </value>
        return this._PopupDragHandleControlID;
    },
    set_PopupDragHandleControlID: function (value) {
        if (this._PopupDragHandleControlID != value) {
            this._PopupDragHandleControlID = value;
            this.raisePropertyChanged('PopupDragHandleControlID');
        }
    },

    get_BackgroundCssClass: function () {
        /// <value type="String">
        /// The CSS class to apply to the background when the modal popup is displayed
        /// </value>
        return this._BackgroundCssClass;
    },
    set_BackgroundCssClass: function (value) {
        if (this._BackgroundCssClass != value) {
            this._BackgroundCssClass = value;
            this.raisePropertyChanged('BackgroundCssClass');
        }
    },

    get_DropShadow: function () {
        /// <value type="Boolean">
        /// Whether or not a drop-shadow should be added to the modal popup
        /// </value>
        return this._DropShadow;
    },
    set_DropShadow: function (value) {
        if (this._DropShadow != value) {
            this._DropShadow = value;
            this.raisePropertyChanged('DropShadow');
        }
    },

    get_Drag: function () {
        /// <value type="Boolean">
        /// Obsolete: Setting the _Drag property is a noop
        /// </value>
        return this._Drag;
    },
    set_Drag: function (value) {
        if (this._Drag != value) {
            this._Drag = value;
            this.raisePropertyChanged('Drag');
        }
    },

    get_OkControlID: function () {
        /// <value type="String">
        /// The ID of the element that dismisses the modal popup
        /// </value>
        return this._OkControlID;
    },
    set_OkControlID: function (value) {
        if (this._OkControlID != value) {
            this._OkControlID = value;
            this.raisePropertyChanged('OkControlID');
        }
    },

    get_CancelControlID: function () {
        /// <value type="String">
        /// The ID of the element that cancels the modal popup
        /// </value>
        return this._CancelControlID;
    },
    set_CancelControlID: function (value) {
        if (this._CancelControlID != value) {
            this._CancelControlID = value;
            this.raisePropertyChanged('CancelControlID');
        }
    },

    get_OnOkScript: function () {
        /// <value type="String">
        /// Script to run when the modal popup is dismissed with the OkControlID
        /// </value>
        return this._OnOkScript;
    },
    set_OnOkScript: function (value) {
        if (this._OnOkScript != value) {
            this._OnOkScript = value;
            this.raisePropertyChanged('OnOkScript');
        }
    },

    get_OnCancelScript: function () {
        /// <value type="String">
        /// Script to run when the modal popup is dismissed with the CancelControlID
        /// </value>
        return this._OnCancelScript;
    },
    set_OnCancelScript: function (value) {
        if (this._OnCancelScript != value) {
            this._OnCancelScript = value;
            this.raisePropertyChanged('OnCancelScript');
        }
    },

    get_repositionMode: function () {
        /// <value type="AjaxControlToolkit.ModalPopupRepositionMode">
        /// Determines if the ModalPopup should be repositioned on window resize/scroll
        /// </value>
        return this._repositionMode;
    },
    set_repositionMode: function (value) {
        if (this._repositionMode !== value) {
            this._repositionMode = value;
            this.raisePropertyChanged('RepositionMode');
        }
    },

    get_OnShowing: function () {
        /// <value type="String" mayBeNull="true">
        /// Generic OnShowing Animation's JSON definition. Played before the Popup is being shown.
        /// </value>
        return this._onShowing.get_json();
    },

    set_OnShowing: function (value) {
        this._onShowing.set_json(value);
        this.raisePropertyChanged('OnShowing');
    },

    get_OnShown: function () {
        /// <value type="String" mayBeNull="true">
        /// Generic OnShown Animation's JSON definition. Played once the Popup is shown.
        /// </value>    
        return this._onShown.get_json();
    },

    set_OnShown: function (value) {
        this._onShown.set_json(value);
        this.raisePropertyChanged('OnShown');
    },

    get_OnHiding: function () {
        /// <value type="String" mayBeNull="true">
        /// Generic OnHiding Animation's JSON definition. Played before the Popup is being hidden.
        /// </value>
        return this._onHiding.get_json();
    },

    set_OnHiding: function (value) {
        this._onHiding.set_json(value);
        this.raisePropertyChanged('OnHiding');
    },

    get_OnHidden: function () {
        /// <value type="String" mayBeNull="true">
        /// Generic OnHidden Animation's JSON definition. Played once the Popup is hidden.
        /// </value>    
        return this._onHidden.get_json();
    },

    set_OnHidden: function (value) {
        this._onHidden.set_json(value);
        this.raisePropertyChanged('OnHidden');
    },

    add_showing: function (handler) {
        /// <summary>
        /// Add an event handler for the showing event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().addHandler('showing', handler);
    },
    remove_showing: function (handler) {
        /// <summary>
        /// Remove an event handler from the showing event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().removeHandler('showing', handler);
    },
    raiseShowing: function (eventArgs) {
        /// <summary>
        /// Raise the showing event
        /// </summary>
        /// <param name="eventArgs" type="Sys.CancelEventArgs" mayBeNull="false">
        /// Event arguments for the showing event
        /// </param>
        /// <returns />

        var handler = this.get_events().getHandler('showing');
        if (handler) {
            handler(this, eventArgs);
        }
    },

    add_shown: function (handler) {
        /// <summary>
        /// Add an event handler for the shown event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().addHandler('shown', handler);
    },
    remove_shown: function (handler) {
        /// <summary>
        /// Remove an event handler from the shown event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().removeHandler('shown', handler);
    },
    raiseShown: function (eventArgs) {
        /// <summary>
        /// Raise the shown event
        /// </summary>
        /// <param name="eventArgs" type="Sys.EventArgs" mayBeNull="false">
        /// Event arguments for the shown event
        /// </param>
        /// <returns />

        var handler = this.get_events().getHandler('shown');
        if (handler) {
            handler(this, eventArgs);
        }
    },

    add_hiding: function (handler) {
        /// <summary>
        /// Add an event handler for the hiding event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().addHandler('hiding', handler);
    },
    remove_hiding: function (handler) {
        /// <summary>
        /// Remove an event handler from the hiding event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().removeHandler('hiding', handler);
    },
    raiseHiding: function (eventArgs) {
        /// <summary>
        /// Raise the hiding event
        /// </summary>
        /// <param name="eventArgs" type="Sys.CancelEventArgs" mayBeNull="false">
        /// Event arguments for the hiding event
        /// </param>
        /// <returns />

        var handler = this.get_events().getHandler('hiding');
        if (handler) {
            handler(this, eventArgs);
        }
    },

    add_hidden: function (handler) {
        /// <summary>
        /// Add an event handler for the hidden event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().addHandler('hidden', handler);
    },
    remove_hidden: function (handler) {
        /// <summary>
        /// Remove an event handler from the hidden event
        /// </summary>
        /// <param name="handler" type="Function" mayBeNull="false">
        /// Event handler
        /// </param>
        /// <returns />
        this.get_events().removeHandler('hidden', handler);
    },
    raiseHidden: function (eventArgs) {
        /// <summary>
        /// Raise the hidden event
        /// </summary>
        /// <param name="eventArgs" type="Sys.EventArgs" mayBeNull="false">
        /// Event arguments for the hidden event
        /// </param>
        /// <returns />

        var handler = this.get_events().getHandler('hidden');
        if (handler) {
            handler(this, eventArgs);
        }
    }
};
Sys.Extended.UI.ModalPopupBehavior.registerClass('Sys.Extended.UI.ModalPopupBehavior', Sys.Extended.UI.DynamicPopulateBehaviorBase);

Sys.Extended.UI.ModalPopupBehavior.invokeViaServer = function (behaviorID, show) {
    /// <summary>
    /// This static function (that is intended to be called from script emitted
    /// on the server) will show or hide the behavior associated with behaviorID
    /// (i.e. to use this, the ModalPopupExtender must have an ID or BehaviorID) and
    /// will either show or hide depending on the show parameter.
    /// </summary>
    /// <param name="behaviorID" type="String">
    /// ID of the modal popup behavior
    /// </param>
    /// <param name="show" type="Boolean">
    /// Whether to show or hide the modal popup
    /// </param>
    var behavior = $find(behaviorID);
    if (behavior) {
        if (show) {
            behavior.show();
        } else {
            behavior.hide();
        }
    }
};

