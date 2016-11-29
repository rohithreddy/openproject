#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class CustomValue::UserStrategy < CustomValue::FormatStrategy
  def typed_value
    return memoized_typed_value if memoized_typed_value

    if value.present?
      RequestStore.fetch(:"user_custom_value_#{value}") do
        self.memoized_typed_value = User.find_by(id: value)
      end
    end
  end

  def parse_value(val)
    if val.is_a?(User)
      self.memoized_typed_value = val

      val.id.to_s
    elsif val.blank?
      super(nil)
    else
      super
    end
  end

  def validate_type_of_value
    unless custom_field.possible_values(custom_value.customized).include?(value)
      :inclusion
    end
  end
end
