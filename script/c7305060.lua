--Scripted by Eerie Code
--Amorphage Plest
function c7305060.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(7305060,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(c7305060.descon)
	e4:SetOperation(c7305060.desop)
	c:RegisterEffect(e4)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCondition(c7305060.accon)
	e3:SetValue(c7305060.aclimit)
	c:RegisterEffect(e3)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c7305060.splimit)
	e2:SetCondition(c7305060.spcon)
	c:RegisterEffect(e2)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c7305060.spop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c7305060.pdcon)
	e0:SetOperation(c7305060.spop)
	c:RegisterEffect(e0)
end

function c7305060.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c7305060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.CheckReleaseGroup(tp,nil,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function c7305060.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(7305060,1)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_EFFECT)
	else Duel.Destroy(c,REASON_RULE) end
end

function c7305060.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe0)
end
function c7305060.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c7305060.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c7305060.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsSetCard(0xe0) and not re:GetHandler():IsImmuneToEffect(e)
end


function c7305060.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe0) and c:IsLocation(LOCATION_EXTRA)
end
function c7305060.pdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM 
end
function c7305060.spop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(7305060,RESET_EVENT+0x1fe0000,0,1)
end
function c7305060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(7305060)>0
end