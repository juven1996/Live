--方界獣ブレード・ガルーディア
--Blade Garudia, the Cubic Beast
--Scripted by Eerie Code
function c78509901.initial_effect(c)
  c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c78509901.spcon)
	e2:SetOperation(c78509901.spop)
	c:RegisterEffect(e2)
	--extra att
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(c78509901.sptg2)
	e4:SetOperation(c78509901.spop2)
	c:RegisterEffect(e4)
end

function c78509901.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe3) and c:IsAbleToGraveAsCost()
end
function c78509901.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c78509901.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c78509901.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c78509901.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end

function c78509901.spfil(c,e,tp)
  return c:IsCode(15610297) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78509901.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c78509901.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingTarget(c78509901.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() end
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if lc>3 then lc=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c78509901.spfil,tp,LOCATION_GRAVE,0,1,lc,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c78509901.thfil(c)
	return c:IsCode(4998619) and c:IsAbleToHand()
end
function c78509901.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
  if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and tg:GetCount()>1 then
		local tc=tg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(c78509901.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(78509901,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c78509901.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end