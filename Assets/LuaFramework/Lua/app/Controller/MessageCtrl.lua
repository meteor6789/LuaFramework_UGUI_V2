
MessageCtrl = {};
local this = MessageCtrl;

local message;
local transform;
local gameObject;

--构建函数--
function MessageCtrl.New()
	printWarning("MessageCtrl.New--->>");
	return this;
end

function MessageCtrl.Awake()
	printWarning("MessageCtrl.Awake--->>");
	panelMgr:CreatePanel('Message', this.OnCreate);
end

--启动事件--
function MessageCtrl.OnCreate(obj)
	gameObject = obj;

	message = gameObject:GetComponent('LuaBehaviour');
	message:AddClick(MessagePanel.btnClose, this.OnClick);

	printWarning("Start lua--->>"..gameObject.name);
end

--单击事件--
function MessageCtrl.OnClick(go)
	destroy(gameObject);
end

--关闭事件--
function MessageCtrl.Close()
	panelMgr:ClosePanel(CtrlNames.Message);
end