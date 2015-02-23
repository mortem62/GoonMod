
CloneClass( GroupAIStateBase )

function GroupAIStateBase.convert_hostage_to_criminal(self, unit, peer_unit)
	unit:movement()._preconvert_team = unit:movement():team()
	self.orig.convert_hostage_to_criminal(self, unit, peer_unit)
end

function GroupAIStateBase.clbk_minion_dies(self, player_key, minion_unit, damage_info)
	local _preconvert_team = minion_unit:movement()._preconvert_team
	if _preconvert_team ~= nil then
		minion_unit:movement():set_team( _preconvert_team )
	end
	self.orig.clbk_minion_dies(self, player_key, minion_unit, damage_info)
end
