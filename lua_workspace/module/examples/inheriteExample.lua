Shape = {
    name="Shape"
}

function Shape:getName()
    print(self.name)
end

function Shape:setName(name)
    self.name = name
end

function Shape:getArea()
end

function Shape:new(shape)
    shape = shape or {}
    setmetatable(shape,{__index = self})
    return shape
end

Circle = {
    radius=10
}

Circle = Shape:new(Circle)
Circle:setName("Circle")

function Circle:getArea()
    return 3.14*self.radius^2
end

local c = Circle:new()
print("Circle area: ",c:getArea())